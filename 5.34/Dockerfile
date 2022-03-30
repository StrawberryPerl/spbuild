# escape=`
# Stage 1 : Get MSYS2 setup
FROM  mcr.microsoft.com/windows:20H2 as msys2
LABEL maintainer="cwhitener@gmail.com"
SHELL ["powershell", "-executionpolicy", "bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/spbuild
ENV LANG=en_US.UTF-8 `
    GIT_TERMINAL_PROMPT=0 `
    MSYSTEM=MINGW64 `
    MSYS2_PATH_TYPE=inherit `
    CHERE_INVOKING=1 `
    MINGW_PATH="C:/spbuild/msys64/usr/bin"
ADD https://github.com/msys2/msys2-installer/releases/download/2022-03-19/msys2-base-x86_64-20220319.sfx.exe c:/Windows/temp
RUN $env:PATH = $env:MINGW_PATH + ';' + $env:PATH; `
  & C:/Windows/temp/msys2-base-x86_64-20220319.sfx.exe -y -oC:/spbuild/; `
  bash -lc 'exit;'; `
  bash -lc 'pacman --noconfirm -Syuu; exit'; `
  bash -lc 'pacman --noconfirm -Syuu; exit'; `
  bash -lc 'pacman --noconfirm -Scc; exit'; `
  bash -lc 'pacman -Sy --noconfirm curl wget ca-certificates openssh openssl nano tar xz p7zip zip unzip bzip2;' `
  bash -lc 'pacman -Sy --noconfirm patch git make autoconf libtool nano automake man flex bison pkg-config;' `
  bash -lc 'pacman -Sy --noconfirm perl-libwww perl-IPC-Run3 perl-IO-Socket-SSL perl-Archive-Zip perl-LWP-Protocol-https perl-Digest-SHA;' `
  bash -lc 'pacman -Sy --noconfirm python2;' `
  bash -lc 'pacman -Syu --noconfirm;' 

# Stage 2 : Get WinLibs in place
from msys2 as winlibs
SHELL ["powershell", "-executionpolicy", "bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/spbuild
ENV LANG=en_US.UTF-8 `
    GIT_TERMINAL_PROMPT=0 `
    MSYSTEM=MINGW64 `
    MSYS2_PATH_TYPE=inherit `
    CHERE_INVOKING=1 `
    MINGW_PATH="C:/spbuild/msys64/usr/bin" `
    WINLIBS_PATH="C:/spbuild/mingw64/bin"
ADD https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-13.0.0-9.0.0-ucrt-r2/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip c:/Windows/temp
RUN Expand-Archive "C:/Windows/temp/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip" -DestinationPath "C:/windows/temp/winlibs"; `
  Remove-Item "C:/Windows/temp/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip" -Force; `
  Move-Item "C:/Windows/temp/winlibs/mingw64" "./mingw64"; `
  Remove-Item "C:/Windows/temp/winlibs" -Recurse -Force; `
  Copy-Item "./mingw64/bin/mingw32-make.exe" -Destination "./mingw64/bin/gmake.exe"; `
  Copy-Item "./mingw64/bin/mingw32-make.exe" -Destination "./mingw64/bin/make.exe"; `
  $env:PATH = $env:WINLIBS_PATH + ';' + $env:PATH; `
  $env:PATH = $env:MINGW_PATH + ';' + $env:PATH;

# Stage 3: get WiX installed
from winlibs as wix
SHELL ["powershell", "-executionpolicy", "bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/spbuild
ENV LANG=en_US.UTF-8 `
    GIT_TERMINAL_PROMPT=0 `
    MSYSTEM=MINGW64 `
    MSYS2_PATH_TYPE=inherit `
    CHERE_INVOKING=1 `
    MINGW_PATH="C:/spbuild/msys64/usr/bin" `
    WINLIBS_PATH="C:/spbuild/mingw64/bin" `
    WIX_PATH="C:/spbuild/sw/wix311"
ADD https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip C:/Windows/temp
RUN Expand-Archive "C:/Windows/temp/wix311-binaries.zip" -DestinationPath "C:/spbuild/sw/wix311"; `
  Remove-Item "C:/Windows/temp/wix311-binaries.zip" -Force; `
  $env:PATH = $env:WINLIBS_PATH + ';' + $env:PATH; `
  $env:PATH = $env:MINGW_PATH + ';' + $env:PATH; `
  $env:PATH = $env:WIX_PATH + ';' + $env:PATH;
