# Make sure we only attempt to work for PowerShell v5 and greater
# this allows the use of classes.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PowerShell v5.0+ is required for psperl. https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6";
}
Write-Host("We have a sufficient version of PowerShell");
Write-Host("");
[string]$rootDir = 'C:\spbuild\';

# Ensures that Invoke-WebRequest uses TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ExtractArchive
function ExtractArchive {
    param (
        [string]$archive_path = '',
        [string]$out_dir = '',
        [bool]$no_tar = $False
    )
    # tar.exe from Cygwin or MSYS may struggle with Windows-style paths so
    # ensure we are using the one that came with Windows 10
    $tar_path = "$env:WINDIR\system32\tar.exe";
    if (-not ($no_tar) -and ([System.IO.File]::Exists($tar_path))) {
        [void](New-Item -ItemType Directory -Path $out_dir -Force);
        & $tar_path -xf $archive_path -C $out_dir;
        if (-Not $?) {
            Remove-Item -Recurse -Force $out_dir;
            throw "Unable to extract the archive.";
        }
    }
    else {
        # Expand-Archive is much slower than tar, so we only use it as a
        # fallback
        # don't show the progress bar. huge speedup
        $ProgressPreference = 'SilentlyContinue';
        Expand-Archive $archive_path -DestinationPath $out_dir;
        # put it back to normal
        $ProgressPreference = 'Continue';
    }
}

# DownloadFile
function DownloadFile {
    param (
        [string]$url = '',
        [string]$output = '',
        [string]$checksum = ''
    )
    # don't show the download progress bar. huge speedup
    $ProgressPreference = 'SilentlyContinue';
    Invoke-WebRequest -Uri $url -OutFile $output
    # powershell -command {
    #     $cli = New-Object System.Net.WebClient;
    #     $cli.Headers['User-Agent'] = 'myUserAgentString';
    #     $cli.DownloadFile($url, $output);
    # }
    # put it back to normal
    $ProgressPreference = 'Continue';
    # we SHOULD now have the file
    if (![System.IO.File]::Exists($output)) {
        throw "We tried to download the file, but something went wrong";
    }
    # check the SHA1 checksums
    [String]$sum = (Get-FileHash -Path $output -Algorithm SHA256).hash;
    if ($sum -ne $checksum) {
        Remove-Item -Path $output -Force;
        throw "The file's SHA256 checksum hash is off. Deleting the file.";
    }
}

# Ensure we have a $($rootDir) folder
if (!(Test-Path "$($rootDir)")) {
    Write-Host("Creating a folder, $($rootDir)");
    New-Item -ItemType Directory -Force -Path "$($rootDir)"
}
Write-Host("We have a $($rootDir) folder.");
Write-Host("");

# Ensure we have a Z: drive
if (!(Test-Path Z:)) {
    Write-Host("Creating a drive map of Z: to $($rootDir)");
    New-PSDrive -Name "Z" -PSProvider "FileSystem" -Root "$($rootDir)"
}
Write-Host("We have a Z: drive.");
Write-Host("");

# Ensure we have a $($rootDir)\_zips folder
if (!(Test-Path "$($rootDir)_zips")) {
    Write-Host("Creating a folder, $($rootDir)_zips");
    New-Item -ItemType Directory -Force -Path "$($rootDir)_zips"
}
Write-Host("We have a $($rootDir)_zips folder.");
Write-Host("");

# Ensure we have a $($rootDir)sw folder
if (!(Test-Path "$($rootDir)sw")) {
    Write-Host("Creating a folder, $($rootDir)sw");
    New-Item -ItemType Directory -Force -Path "$($rootDir)sw"
}
Write-Host("We have a $($rootDir)sw folder");
Write-Host(""); 

# Ensure we have msys2
if (!(Test-Path "$($rootDir)msys64")) {
    [String]$url = "http://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-20210604.sfx.exe";
    [String]$file = "$($rootDir)_zips\msys2-x86_64-20210604.sfx.exe";
    [String]$checksum = "2D7BDB926239EC2AFACA8F9B506B34638C3CD5D18EE0F5D8CD6525BF80FCAB5D";
    if (![System.IO.File]::Exists($file)) {
        Write-Host("Downloading $($url).");
        DownloadFile -url $url -output $file -checksum $checksum;
    }
    
    # just execute the self extracting zip file
    # -y assume yes
    # -o sets the target path
    & $file -y -o"$($rootDir)";
    if (-Not $?) {
        Remove-Item -Recurse -Force "$($rootDir)msys64";
        throw "Unable to extract the archive.";
    }
    Remove-Item -Force $file;
    [String]$bash = "$($rootDir)msys64\usr\bin\bash.exe";
    # run it for the first time
    & $bash -lc 'exit';
    # update all of the core stuff
    & $bash -lc 'pacman --noconfirm -Syuu; exit';
    & $bash -lc 'pacman --noconfirm -Syuu; exit';
    & $bash -lc 'pacman --noconfirm -Scc; exit';
    # ensure no spawned processes are left running
    taskkill /F /FI "MODULES eq msys-2.0.dll"
}
Write-Host("We have a $($rootDir)msys64 folder");
Write-Host("");

# Ensure we have WiX
if (!(Test-Path "$($rootDir)sw\wix311")) {
    [String]$url = "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip";
    [String]$file = "$($rootDir)_zips\wix311-binaries.zip";
    [String]$checksum = "2C1888D5D1DBA377FC7FA14444CF556963747FF9A0A289A3599CF09DA03B9E2E";
    if (![System.IO.File]::Exists($file)) {
        Write-Host("Downloading $($url).");
        DownloadFile -url $url -output $file -checksum $checksum;
    }

    # this one's weird, so we can't use tar on it
    ExtractArchive -archive_path $file -out_dir "$($rootDir)sw\wix311" -no_tar $True;
    Remove-Item -Force $file;
}
Write-Host("We have a $($rootDir)sw\wix311 folder");
Write-Host("");

# Ensure we have cmake
if (!(Test-Path "$($rootDir)sw\cmake")) {
    [String]$url = "https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5.zip";
    [String]$file = "$($rootDir)_zips\cmake-3.20.5.zip";
    [String]$checksum = "37FD84DB08ECC517B2274C06161978744AB6F3459A89C9AA9B68BEF7E053DD61";
    if (![System.IO.File]::Exists($file)) {
        Write-Host("Downloading $($url). This may take some time as it's 15.8MB.");
        DownloadFile -url $url -output $file -checksum $checksum;
    }
    # extract to a temporary location before moving into place
    ExtractArchive -archive_path $file -out_dir "$($rootDir)_zips\cmake"

    Move-Item "$($rootDir)_zips\cmake\cmake-3.20.5" "$($rootDir)sw\cmake";
    Remove-Item "$($rootDir)_zips\cmake" -Recurse -Force;
    Remove-Item -Force $file;
}
Write-Host("We have a $($rootDir)sw\cmake folder");
Write-Host("");

# Ensure we have winlibs
if (!(Test-Path "$($rootDir)\mingw64")) {
    [String]$url = "https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-13.0.0-9.0.0-ucrt-r2/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip";
    [String]$file = "$($rootDir)_zips\winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip";
    [String]$checksum = "4CB9ECB49F4C07BC218031B4AC0847D1510097E22B8556C650845CCA11DD0B4A";
    if (![System.IO.File]::Exists($file)) {
        Write-Host("Downloading $($url). This may take some time as it's 231MB.");
        DownloadFile -url $url -output $file -checksum $checksum;
    }
    # extract to a temporary location before moving into place
    ExtractArchive -archive_path $file -out_dir "$($rootDir)_zips\winlibs"

    Move-Item "$($rootDir)_zips\winlibs\mingw64" "$($rootDir)\mingw64";
    Remove-Item "$($rootDir)_zips\winlibs" -Recurse -Force;
    Remove-Item -Force $file;
    Copy-Item "$($rootDir)mingw64\bin\mingw32-make.exe" -Destination "$($rootDir)mingw64\bin\gmake.exe"
    Copy-Item "$($rootDir)mingw64\bin\mingw32-make.exe" -Destination "$($rootDir)mingw64\bin\make.exe"
}
Write-Host("We have a $($rootDir)\mingw64 folder");
Write-Host("");

# ensure no spawned processes are left running
taskkill /F /FI "MODULES eq msys-2.0.dll"
