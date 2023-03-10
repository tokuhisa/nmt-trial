#! /bin/bash

set -e
set -x

ROOT_DIR=$PWD
ICU_VERSION=${ICU_VERSION:-72.1}

mkdir outputs
mkdir outputs/icu
mkdir outputs/Release
mkdir outputs/Debug

curl -L -O -nv https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION/./-}/icu4c-${ICU_VERSION/./_}-Win64-MSVC2019.zip
unzip *.zip
unzip *_Release/icu-windows.zip -d icu
rm -r *_Release

cp $ROOT_DIR/icu/bin64/icudt*.dll $ROOT_DIR/outputs/icu/
cp $ROOT_DIR/icu/bin64/icuuc*.dll $ROOT_DIR/outputs/icu/

rm -rf build
mkdir build
cd build

# Release build
cmake -DLIB_ONLY=ON -DICU_ROOT=$ROOT_DIR/icu/ -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/Release/ -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release --target install

# Debug build
cmake -DLIB_ONLY=ON -DICU_ROOT=$ROOT_DIR/icu/ -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/Debug/ -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --config Debug --target install
