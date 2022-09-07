# escape=`
# Stage 1 : Get WinLibs in place
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as winlibs
SHELL ["powershell", "-executionpolicy", "bypass", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/spbuild
ENV LANG=en_US.UTF-8
ENV GIT_TERMINAL_PROMPT=0
ENV CHERE_INVOKING=1
ENV MINGW_PATH="Z:/msys64;Z:/msys64/usr/bin"
ENV WINLIBS_PATH="Z:/mingw64/bin"
ENV WIX_PATH="Z:/sw/wix311"
ENV CMAKE_PATH="Z:/sw/cmake/bin"
ENV GIT_PATH="Z:/git/cmd"
ENV MSYSTEM=MINGW64
ENV MSYS2_PATH_TYPE=inherit
ADD https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-13.0.0-9.0.0-ucrt-r2/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip c:/Windows/temp
ADD https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-windows-x86_64.zip C:/Windows/temp
ADD https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip C:/Windows/temp
ADD https://github.com/msys2/msys2-installer/releases/download/2022-03-19/msys2-base-x86_64-20220319.sfx.exe c:/Windows/temp
ADD https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/PortableGit-2.36.1-64-bit.7z.exe c:/Windows/temp
# Expand and setup WinLibs
RUN Expand-Archive "C:/Windows/temp/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip" -DestinationPath "C:/windows/temp/winlibs"; `
  Remove-Item "C:/Windows/temp/winlibs-x86_64-posix-seh-gcc-11.2.0-llvm-13.0.0-mingw-w64ucrt-9.0.0-r2.zip" -Force; `
  Move-Item "C:/Windows/temp/winlibs/mingw64" "./mingw64"; `
  Remove-Item "C:/Windows/temp/winlibs" -Recurse -Force; `
  Copy-Item "./mingw64/bin/mingw32-make.exe" -Destination "./mingw64/bin/gmake.exe"; `
  Copy-Item "./mingw64/bin/mingw32-make.exe" -Destination "./mingw64/bin/make.exe";
# Expand and setup Wix
RUN Expand-Archive "C:/Windows/temp/wix311-binaries.zip" -DestinationPath "C:/spbuild/sw/wix311"; `
  Remove-Item "C:/Windows/temp/wix311-binaries.zip" -Force;
# Expand and setup cmake
RUN Expand-Archive "C:/Windows/temp/cmake-3.24.1-windows-x86_64.zip" -DestinationPath "C:/Windows/temp/"; `
  Remove-Item "C:/Windows/temp/cmake-3.24.1-windows-x86_64.zip" -Force; `
  Move-Item "C:/Windows/temp/cmake-3.24.1-windows-x86_64" "C:/spbuild/sw/cmake";
# Expand and setup msys2 and make the PATH sticky
RUN C:/Windows/temp/msys2-base-x86_64-20220319.sfx.exe -y -oC:/spbuild/; `
  Remove-Item "C:/Windows/temp/msys2-base-x86_64-20220319.sfx.exe";
# Expand Git and add it to the path
RUN C:/Windows/temp/PortableGit-2.36.1-64-bit.7z.exe -y -oC:/spbuild/git;
  # Remove-Item "C:/Windows/temp/PortableGit-2.36.1-64-bit.7z.exe";
# Put some path settings in our $Profile and set Z:/ to C:/spbuild/
RUN New-Item -Path $Profile -ItemType File -Force; `
  '$env:PATH = $env:MINGW_PATH + \";\" + $env:PATH;' > $Profile; `
  '$env:PATH = $env:WINLIBS_PATH + \";\" + $env:PATH;' >> $Profile; `
  '$env:PATH = $env:WIX_PATH + \";\" + $env:PATH;' >> $Profile; `
  '$env:PATH = $env:CMAKE_PATH + \";\" + $env:PATH;' >> $Profile; `
  '$env:PATH = $env:GIT_PATH + \";\" + $env:PATH;' >> $Profile; `
  'subst Z: C:\spbuild;' >> $Profile;
