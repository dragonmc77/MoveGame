function global:moveGame() {
    $selection = $PlayniteApi.MainView.SelectedGames
    <#  check that only one game is selected #>
    if ($selection.Count -gt 1) {
        $PlayniteApi.Dialogs.ShowErrorMessage("Only one game can be moved at a time.","Please select only one game")
        break
    }
    $selectedGame = $selection[0]
    $installDir = $selectedGame.InstallDirectory

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
    if (Test-Path -Path $installDir) {
        $newDir = $PlayniteApi.Dialogs.SelectFolder()
        if (-not $newDir) {break}
        Move-Item -Path $installDir -Destination $newDir -Force -ErrorAction SilentlyContinue -ErrorVariable err
        if ($err) {$PlayniteApi.Dialogs.ShowErrorMessage("Most likely cause is Playnite not running as admin","Error Moving Folder"); break} 
    }

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