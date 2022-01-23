#!/bin/bash

machine=$(uname -m)

function clean() {
  rm -rf \
     src/ \
     pkg/ \
     mingw-w64-${machine}-*.pkg.tar.{xz,zst} \
     *.src.tar.gz \
     logpipe.* \
     mingw-w64-*-${machine}-*.log \
     *.log.[0-9]*
}

function build() {
  case $machine in
    i686)   MINGW_ARCH=mingw32 ;;
    x86_64) MINGW_ARCH=mingw64 ;;
  esac

  pacman -S --asdeps --needed --noconfirm base

  MINGW_ARCH=${MINGW_ARCH} updpkgsums

  pacman -S --asdeps --needed --noconfirm mingw-w64-${machine}-binutils

  MINGW_ARCH=${MINGW_ARCH} makepkg-mingw --noconfirm -srLf

  if [ ! -f "/home/custompkgs/custom.db.tar.gz" ]; then
    mkdir -p /home/custompkgs
    repo-add /home/custompkgs/custom.db.tar.gz
    pacman -Sy
  fi
  local _pkg_files=$(find . -type f -name "mingw-w64-${machine}-*.pkg.tar.zst")
  for _pkg_file in ${_pkg_files[@]}; do
    cp $_pkg_file                              /home/custompkgs
    repo-add /home/custompkgs/custom.db.tar.gz /home/custompkgs/$_pkg_file
    pacman -Sy
  done
}

function install() {
  local _pkg_files=$(find . -type f -name "mingw-w64-${machine}-*.pkg.tar.zst")
  for _pkg_file in ${_pkg_files[@]}; do
    pacman -U --asdeps --noconfirm $_pkg_file
  done
}

function execute() {
  local execute_dir=`pwd`
  while [ -n "$1" ]; do
    case $1 in
      "-d"     ) shift; cd $1 ; shift ;;
      "-32"    ) shift; machine=i686  ;;
      "-64"    ) shift; machine=x86_64;;
      "clean"  ) shift; clean   ;;
      "build"  ) shift; build   ;;
      "install") shift; install ;;
              *) break;;
    esac
  done
  cd $execute_dir
}

function do_execute() {
  case $1 in
    "-e") shift; execute    $@                     ;;
    "-d") shift; execute -d $@ clean build install ;;
    "-b") shift; execute -d $@ clean build         ;;
    "-f") shift; local file=$1; shift;
      readarray -t dirs < $file
      for dir in ${dirs[@]}; do
        echo -e "\033[31m>>> (Re)Building $dir <<<\033[0m"
        execute -d $dir $@ clean build
      done
    ;;
    "-i") shift; local file=$1; shift;
      readarray -t dirs < $file
      for dir in ${dirs[@]}; do
        echo -e "\033[31m>>> (Re)Installing $dir <<<\033[0m"
        execute -d $dir $@ install
      done
    ;;
  esac
}

do_execute $@
