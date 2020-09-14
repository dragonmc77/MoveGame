param (
    [string]$Link,
    [string]$Target
)
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
if (Test-Path -Path $Link) {
    Write-Host "Path specified as link already exists. Moving folder..." -ForegroundColor Yellow
    Move-Item -Path $Link -Destination $Target -Force -ErrorAction SilentlyContinue -ErrorVariable err
    if (-not $err) {Write-Host "Folder moved successfully." -ForegroundColor Green} 
        else {Write-Error "Could not move folder."; break}
}

if (-not $Link.EndsWith("\")) {$Link = $Link + "\"}
if (-not $Target.EndsWith("\")) {$Target = $Target + "\"}
$success = [mklink.symlink]::CreateSymbolicLink($Link,$Target,3)
if ($success) {Write-Host "Symbolic link created successfully" -ForegroundColor Green}
    else {Write-Error "Could not create symbolic link."}
