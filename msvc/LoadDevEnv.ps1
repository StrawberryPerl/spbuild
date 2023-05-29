# Make sure we only attempt to work for PowerShell v5 and greater
# this allows the use of classes.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PowerShell v5.0+ is required for psperl. https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6";
}

# location in which this script resides
[String]$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition);

# now do the crap we need to load the environment
[String]$vswherePath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe";
[Boolean]$haveVSWhere = [System.IO.File]::Exists($vswherePath);

Write-Host("Do we have ${vswherePath} installed? ${haveVSWhere}");
if (!$haveVSWhere) {
    throw "Not found. Please run ${scriptPath}/InstallBuildTools.ps1 to get things setup.";
}

# Visual Studio path <https://github.com/microsoft/vswhere/wiki/Find-VC>
[String]$vsPath = &"${vswherePath}" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationpath
if (!$vsPath) {
    throw "Unable to find the installation path for Visual Studio.";
}
Write-Host "Do we have a version of Visual Studio that's usable? ${vsPath}"

[String]$dllPath = (& "${vswherePath}" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find Common7\Tools\Microsoft.VisualStudio.DevShell.dll)
if (!$dllPath) {
    throw "No path to run the DLL environment import. Please run ${scriptPath}/InstallBuildTools.ps1 to get things setup.";
}
Write-Host("DLL Path: ${dllPath}");
Import-Module $dllPath;

Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -DevCmdArguments '-arch=x64'
Set-Item -Path "env:CC" -Value "cl.exe"
Set-Item -Path "env:CXX" -Value "cl.exe"

# [String]$launchPath = (& "${vswherePath}" -latest -prerelease -products * -requires Microsoft.Component.MSBuild -find Common7\Tools\Launch-VsDevShell.ps1)
# if (!$launchPath) {
#     throw "No path to run the PowerShell launcher. Please run ${scriptPath}/InstallBuildTools.ps1 to get things setup.";
# }
# Write-Host("Launcher Path: ${launchPath}");
# & $launchPath;
