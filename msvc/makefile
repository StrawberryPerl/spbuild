# Sample makefile

#!include <win32.mak>

all: foo.exe
clean:
  del foo.obj foo.exe

.c.obj:
  $(cc) $(cdebug) $(cflags) $(cvars) $*.c

# foo.exe: foo.obj
#   $(link) $(ldebug) $(conflags) -out:foo.exe $(conlibs)
