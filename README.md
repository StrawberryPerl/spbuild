# NAME

StrawberryPerl Builder - Setup an environment for building Strawberry Perl

# SYNOPSIS

Let's build and run our container from a PowerShell.

```PowerShell
# PS C:\Users\genio>
git clone https://github.com/StrawberryPerl/spbuild.git .
cd .\spbuild\5.34
# PS C:\Users\genio\spbuild\5.34>
docker build -t strawberryperl/strawbuild:latest -t strawberryperl/strawbuild:5.34 .
docker run --rm -it strawberryperl/strawbuild:latest powershell.exe
```

Now, we're in our container we move to the Z: drive and fix a few things in MSYS2:

```PowerShell
# PS C:\spbuild>
z:
# PS Z:\>
bash -c ./gpgfix.sh
```

Next we need to install a number MSYS2 packages so that we're good to go in our build processes,
and then start a bash shell.

```PowerShell
# PS Z:\>
& .\init_msys2.ps1
git clone https://github.com/StrawberryPerl/build-extlibs.git extlib
cd extlib
# PS Z:\extlib\>
bash
```

Great! We've now got MSYS2 setup. We've got our [build-extlibs](https://github.com/StrawberryPerl/build-extlibs#building-libraries)
repo checked out and we're ready to try to build some external libraries
using the bash shell.

```bash
# ContainerAdministrator@767e415f72ad MINGW64 /z/extlib
./build.sh 5034 __
```

Now we have to wait a really, really long time. You can get a good idea of how things worked out for you by grepping through the log files:

```bash
# ContainerAdministrator@767e415f72ad MINGW64 /z/extlib
grep -E 'retval=' _5034__/*.build.log
```

## Issues:

* The build process is reasonably complex and involved.
* There isn't a working compiler/linker for Windows that we can rely
on, so we have to build our own on top of MSYS2 using MinGW.
* The compiler choice means DLLs built by MSVC cannot be used so we
have to build our own of everything.
* Many libraries need to be patched so they work on Windows.
Fortunately patches can often be borrowed or adapted from the
[MSYS project](https://github.com/msys2/MINGW-packages).

The needed process looks like this:

```mermaid
  graph TD;
      A[A Fixed Compiler/Toolchain]-->B[Build external libraries, some need Perl];
      E[Patch External Libraries]-->B;
      A-->C[Build our Perl];
      C-->B;
      B-->D[Install modules into built Perl];
      C-->D;
      D-->F[Package built Perl];
      F-->G[Release package to web];
style A fill:#2da44e
style B fill:#DAA520
style C fill:#DAA520
style D fill:#DAA520
style E fill:#DAA520
```

Part of the biggest issue is getting help. The complexities listed
above scare off most people. So, we're trying to find ways to make all
of that a bit of an easier starting point for anyone wanting to
contribute. Running docker containers for Windows is a pain, but at
least if it's all there and automated for the builds, we might be able
to get some more help since they could simply update and run the
containers for whatever they think they could help with. That's what
the idea behind this repository is.

## Possible Solution:

Build all of the compiler environment and then the third-party
libraries necessary for Perl with one docker suite that stores the
results in S3 or something. Then run a second docker suite that grabs
all of that and builds Perl for us with the libraries and Perl modules
we know we're wanting. Then yet a third docker suite that packages
everything up for distribution and pushes it to the site.

## What We Need:

We'd be more than happy to have feedback and/or help with a better solution
or with this Docker idea.

# AUTHOR

Chase Whitener `<capoeirab@cpan.org>`

# COPYRIGHT & LICENSE

Copyright 2019, Chase Whitener, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.
