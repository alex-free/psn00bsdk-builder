#!/bin/bash

ver=1.0.3
release=psn00bsdk-builder-v$ver
set -e

cd "$(dirname "$0")"
rm -rf "$release"*

if [ "$1" == "clean" ]; then
    exit 0
fi

mkdir "$release"
cp -r build.sh sdk.sh platform.h-patch tinyxml2.cpp-patch changelog.md readme.md unlicense.txt "$release"
chmod -R 777 "$release"
zip -r "$release".zip "$release"
