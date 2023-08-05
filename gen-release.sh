#!/bin/bash

ver=1.0
release=psn00bsdk-builder-v$ver
set -e

cd "$(dirname "$0")"
rm -rf "$release"*

if [ "$1" == "--clean" ]; then
    exit 0
fi

mkdir "$release"
cp -r build.sh readme.md unlicense.txt "$release"
chmod -R 777 "$release"
zip -r "$release".zip "$release"
