function global:moveGame() {
    $selection = $PlayniteApi.MainView.SelectedGames
    <#  check that only one game is selected #>
    if ($selection.Count -gt 1) {
        $PlayniteApi.Dialogs.ShowErrorMessage("Only one game can be moved at a time.","Please select only one game")
        break
    }
    $selectedGame = $selection[0]
    $installDir = $selectedGame.InstallDirectory

    # since junction points are only supported on NTFS volumes, proceed only if that check is successful
    if (-not (global:Test-NTFS -Path $installDir)) {
        $PlayniteApi.Dialogs.ShowErrorMessage("The path:`n$installDir`nis either not a local path or not an NTFS volume.","Path Not Supported"); break
    }    

    <#  import the mklink functionality from the shell #>
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    namespace mklink
    {
        public class symlink
        {
            [DllImport("kernel32.dll")]
            public static extern bool CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, int dwFlags);
        }
    }
"@
    # proceed only if the installation path exists
    if (-not (Test-Path -Path $installDir)) {break}

    # prompt for a the new directory to move the game folder to
    $newDir = $PlayniteApi.Dialogs.SelectFolder()
    if (-not $newDir) {break}
    
    # since junction points are only supported on NTFS volumes, proceed only if that check is successful
    if (-not (global:Test-NTFS -Path $newDir)) {
        $PlayniteApi.Dialogs.ShowErrorMessage("The destination path:`n$newDir`nis either not a local path or not an NTFS volume.","Path Not Supported"); break
    }

    # move the folder
    Move-Item -Path $installDir -Destination $newDir -Force -ErrorAction SilentlyContinue -ErrorVariable err
    if ($err) {$PlayniteApi.Dialogs.ShowErrorMessage("Most likely cause is Playnite not running as admin","Error Moving Folder"); break} 

    # mklink expects paths passed to have a trailing backslash (\), so check for that, then make the link
    if (-not $installDir.EndsWith("\")) {$installDir = $installDir + "\"}
    if (-not $newDir.EndsWith("\")) {$newDir = $newDir + "\"}
    $success = [mklink.symlink]::CreateSymbolicLink($installDir,$newDir,3)
    if ($success) {
        $response = $PlayniteApi.Dialogs.ShowMessage("The game folder was moved and a link was created.","Success")
    }
    else {
        $response = $PlayniteApi.Dialogs.ShowErrorMessage("Failed creating link.","Failed")
    }
}

function global:Test-NTFS {
    param ([string]$Path)

    $driveLetter = [IO.Path]::GetPathRoot($newDir).Substring(0,1)
    $volume = Get-Volume | Where-Object {$_.DriveLetter -eq $driveLetter}
    if ($volume) {
        if ($volume.FileSystemType -eq "NTFS") {return $true} else {return $false}
    } else {return $false}
}