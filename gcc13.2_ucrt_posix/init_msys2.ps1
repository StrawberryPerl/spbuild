# Make sure we only attempt to work for PowerShell v5 and greater
# this allows the use of classes.
if ($PSVersionTable.PSVersion.Major -lt 5) {
    throw "PowerShell v5.0+ is required for psperl. https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6";
}
Write-Host("We have a sufficient version of PowerShell.");
Write-Host("");

Start-Process -FilePath "bash" -ArgumentList "-c 'exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman --noconfirm -Syuu; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman --noconfirm -Syuu; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman --noconfirm -Scc; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm curl wget ca-certificates openssh openssl nano tar xz p7zip zip unzip bzip2; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm patch git make autoconf libtool nano automake man flex bison pkg-config; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm perl-libwww perl-IPC-Run3 perl-IO-Socket-SSL perl-Archive-Zip perl-LWP-Protocol-https perl-Digest-SHA; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm gettext-devel gperf; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm python; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm vim; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm gperf gettext-devel ; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm vim gperf gettext-devel; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm ccache mingw-w64-x86_64-ccache; exit'" -Wait -NoNewWindow;
Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Sy --noconfirm meson ninja; exit'" -Wait -NoNewWindow;

Start-Process -FilePath "bash" -ArgumentList "-c 'pacman -Syu --noconfirm; exit'" -Wait -NoNewWindow;
