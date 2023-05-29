# Make sure we only attempt to work for PowerShell v5 and greater
# this allows the use of classes.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PowerShell v5.0+ is required for psperl. https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6";
}

# location in which this script resides
[String]$scriptPath = (Split-Path -parent $MyInvocation.MyCommand.Definition);

function Invoke-Command() {
    param ( [string]$program = $(throw "Please specify a program" ),
        [string]$argumentString = "",
        [switch]$waitForExit )

    $psi = new-object "Diagnostics.ProcessStartInfo"
    $psi.FileName = $program 
    $psi.Arguments = $argumentString
    $proc = [Diagnostics.Process]::Start($psi)
    if ( $waitForExit ) {
        $proc.WaitForExit();
    }
}

[String]$vsBuildPath = "${scriptPath}\vs_buildtools.exe";
[Boolean]$haveVSBuildTools = [System.IO.File]::Exists($vsBuildPath);
Write-Host("Do we have ${vsBuildPath}? ${haveVSBuildTools}");
if (!$haveVSBuildTools) {
    [String]$vsBuildToolsURL = 'https://aka.ms/vs/17/release/vs_buildtools.exe';
    Write-Host("    We don't yet have the vs_buildtools.exe installer for VS Build Tools.");
    Write-Host("    We will need to download that from Microsoft: ${vsBuildToolsURL}");
    Invoke-WebRequest -Uri $vsBuildToolsURL -OutFile $vsBuildPath;
    $haveVSBuildTools = [System.IO.File]::Exists($vsBuildPath);
    Write-Host("Do we have ${vsBuildPath} now? ${haveVSBuildTools}");
}

Write-Host -NoNewline "Run the installer and ensure we have VSBuildTools setup correctly.";
[String]$perlVSConfig = "${scriptPath}\perl.vsconfig";
Invoke-Command -wait -program $vsBuildPath -argumentString "--passive --wait --config ${perlVSconfig}";
Write-Host("    Done.");
