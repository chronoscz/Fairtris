#!/bin/bash

# 64-bit
#ARCH=x86_64-linux

BUILD_ROOT=/tmp/build-root/fairtris
mkdir -p $BUILD_ROOT
cp -r -f ../.. $BUILD_ROOT
cp -r -f debian $BUILD_ROOT
cd $BUILD_ROOT
dpkg-buildpackage -b -rfakeroot -us -uc
