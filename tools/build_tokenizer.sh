#! /bin/bash

set -e
set -x

ROOT_DIR=$PWD
ICU_VERSION=${ICU_VERSION:-72.1}

mkdir outputs

curl -L -O -nv https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION/./-}/icu4c-${ICU_VERSION/./_}-Win64-MSVC2019.zip
unzip *.zip
unzip *_Release/icu-windows.zip -d icu
rm -r *_Release

rm -rf build
mkdir build
cd build
cmake -DLIB_ONLY=OFF -DICU_ROOT=$ROOT_DIR/icu/ -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/ -DCMAKE_BUILD_TYPE=Debug ..
cmake --build . --config Debug --target install

cp $ROOT_DIR/icu/bin64/icudt*.dll $ROOT_DIR/outputs/bin/
cp $ROOT_DIR/icu/bin64/icuuc*.dll $ROOT_DIR/outputs/bin/
cp $ROOT_DIR/icu/lib64/icudt*.lib $ROOT_DIR/outputs/lib/
cp $ROOT_DIR/icu/lib64/icuuc*.lib $ROOT_DIR/outputs/lib/
