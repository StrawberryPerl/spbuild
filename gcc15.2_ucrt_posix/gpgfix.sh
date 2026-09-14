#!/usr/bin/env bash

rm -r /etc/pacman.d/gnupg/
pacman-key --init
pacman-key --populate msys2
