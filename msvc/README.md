# NAME

StrawberryPerl MSVC Builder - Setup an environment for building Strawberry Perl using Microsoft Visual C.

# SYNOPSIS

Microsoft has [allowed the free use of MSVC Build Tools](https://developercommunity.visualstudio.com/t/CC-compiler-and-linker-free-CLI-only/10042178) for OpenSource software or to build OpenSource software even when writing closed source code.

For languages, such as Perl, that provide a minimal install set and rely on the user to download and install any necessary libraries that are necessary for Perl language bindings, etc. XS modules require a compiler... in short, it's hard to install lots of useful Perl modules without a build environment. On Linux and MacOS, this is easy. It hasn't been possible on Windows without expecting the user to pay for a Visual Studio license until now.

## Installing MSVC Build Tools

Let's start by checking out this repository and ensuring we have the necessary bits installed for MSVC in order to build our very own Perl.

```PowerShell
# PS C:\Users\genio>
git clone https://github.com/StrawberryPerl/spbuild.git .
cd .\spbuild\msvc\
# PS C:\Users\genio\spbuild\msvc\>
.\InstallBuildTools.ps1
```

This will open a window asking your permission to install the necessary modules lined out in our `perl.vsconfig` file in this repository. While it does load a Window showing you the progress, it will not be interactive in any other way.

## Using MSVC Build Tools

Now that we _have_ a build environment, it's unfortunately not plopped into our PowerShell/CMD environment by default. We have to go through and search for it. We've made this part easy as well:

```PowerShell
# PS C:\Users\genio\spbuild\msvc\>
.\LoadDevEnv.ps1
# PS C:\Users\genio\spbuild\msvc\>
nmake
.\foo.exe
nmake clean
```

As you can see, we've now got a working C compiler that can build our little `Hello World` C application. This means we can proceed with checking out and building Perl.

## Downloading Perl Source and Prepping

Now, let's download version `v5.36.1` from the git tag on the [Perl repo](https://github.com/Perl/perl5) and just throw it in our `_build` directory.


```bash
# PS C:\Users\genio\spbuild\msvc\>
cd _builds
git clone --depth 1 --branch v5.36.1 https://github.com/Perl/perl5.git p5361
cd .\p5361\win32\
# PS C:\Users\genio\spbuild\msvc\_builds\p5361\win32>
```

## Setting the Compiler Version.

At around line 100 in the `Makefile` in the `p5361\win32` directory, you'll see where you need to uncomment the line corresponding to your version of Visual Studio to set the `CCTYPE` variable. It's probably safe to assume you have `MSVC143`.

* Visual Studio 2013 = `MSVC120`
* Visual Studio 2015 = `MSVC140`
* Visual Studio 2017 = `MSVC141`
* Visual Studio 2019 = `MSVC142`
* Visual Studio 2022 = `MSVC143`

# Build Perl

Now we have a development environment, Perl downloaded, the `CCTYPE` variable set, and we're officially ready to build Perl from source.

```bash
# PS C:\Users\genio\spbuild\msvc\_builds\p5361\win32>
nmake
nmake test
nmake install
```

# AUTHOR

Chase Whitener `<capoeirab@cpan.org>`

# COPYRIGHT & LICENSE

Copyright 2019, Chase Whitener, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.
