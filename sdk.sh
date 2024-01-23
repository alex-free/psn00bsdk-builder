#!/bin/bash

prefix=/usr/local/psn00bsdk
export PATH="$prefix"/bin${PATH:+:${PATH}}
export PSN00BSDK_LIBS="$prefix"/lib/libpsn00b
set -e
is_msys2=$(uname -a | grep MSYS | wc -l)

cd "$(dirname "$0")"
rm -rf psn00bsdk
git clone --recursive https://github.com/lameguy64/psn00bsdk
cd psn00bsdk

if [ $is_msys2 -gt 0 ]; then
	patch -u tools/mkpsxiso/tinyxml2/tinyxml2.cpp -i ../tinyxml2.cpp-patch
	patch -u tools/mkpsxiso/src/shared/platform.h -i ../platform.h-patch
fi

cmake --preset default . --install-prefix "$prefix"
cmake --build ./build
cmake --install ./build
cd ../
rm -rf psn00bsdk