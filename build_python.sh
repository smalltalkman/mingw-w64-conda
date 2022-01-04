#!/bin/bash

root=$(pwd)
name=$1
bits=$2

case $bits in
  32) machine=i686 ;;
  64) machine=x86_64 ;;
esac

$root/build.sh                       -d mingw-w64-python-$name   -$bits
pacman -S --asdeps --needed --noconfirm mingw-w64-$machine-python-pip
/mingw$bits/bin/pip check >       $root/mingw-w64-python-$name/mingw-w64-python-$name-$machine-pip-check.log
pacman -Rs                  --noconfirm mingw-w64-$machine-python-{pip,$name}
