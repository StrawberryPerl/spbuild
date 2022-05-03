# NAME

StrawberryPerl Builder - Setup an environment for building Strawberry Perl

# SYNOPSIS

## Issues:

* It's hard to garner help because the build process is so complex and big.
* There isn't a working compiler/linker for Windows that we can rely
on, so we have to build our own on top of MSYS2 using MinGW.
* The compiler choice makes it nearly impossible to use DLLs built by
MSVC so we have to build our own of everything.
* We have to build some libraries never meant for Windows.
* We have to build some libraries that haven't had updates in years.
* We have to build some libraries that rely on Perl for their build
process (fun!)
* Many libraries we have to build have one-off customizations we have
to patch in for our purposes.
* Every time we build these, we have to keep the compiler version and
library binaries at the same exact build throughout the entirety of
the Perl version we're building.
* Once we have all of those things built and ready, we have to build
Perl itself.
* Once we have a built Perl, we have to go through and install some
Perl modules to ship along with it.
* Once we have everything built, we have to package it all up.
* Once it's all packaged up, we have to release it to the site.

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
