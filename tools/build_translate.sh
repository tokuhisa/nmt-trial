#! /bin/bash

set -e
set -x

ROOT_DIR=$PWD

mkdir outputs
mkdir outputs/Release
mkdir outputs/Debug
mkdir outputs/oneAPI
mkdir C:/oneDNN
mkdir C:/oneDNN/Release
mkdir C:/oneDNN/Debug

# See https://github.com/oneapi-src/oneapi-ci for installer URLs
curl -L -nv -o webimage.exe https://registrationcenter-download.intel.com/akdlm/irc_nas/19078/w_BaseKit_p_2023.0.0.25940_offline.exe
./webimage.exe -s -x -f webimage_extracted --log extract.log
rm webimage.exe
./webimage_extracted/bootstrapper.exe -s --action install --components="intel.oneapi.win.mkl.devel" --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 --log-dir=.
# Installed Location: C:\Program Files (x86)\Intel\oneAPI

cp C:/"Program Files (x86)"/Intel/oneAPI/compiler/latest/windows/redist/intel64_win/compiler/libiomp5md.dll $ROOT_DIR/outputs/oneAPI/

ONEDNN_VERSION=3.0.1
curl -L -O https://github.com/oneapi-src/oneDNN/archive/refs/tags/v${ONEDNN_VERSION}.tar.gz
tar xf *.tar.gz && rm *.tar.gz
cd oneDNN-*

# Release build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="C:/oneDNN/Release" -DDNNL_LIBRARY_TYPE=STATIC -DDNNL_BUILD_EXAMPLES=OFF -DDNNL_BUILD_TESTS=OFF -DDNNL_ENABLE_WORKLOAD=INFERENCE -DDNNL_ENABLE_PRIMITIVE="CONVOLUTION;REORDER" .
cmake --build . --config Release --target install --parallel 2

# Debug build
# cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX="C:/oneDNN/Debug" -DDNNL_LIBRARY_TYPE=STATIC -DDNNL_BUILD_EXAMPLES=OFF -DDNNL_BUILD_TESTS=OFF -DDNNL_ENABLE_WORKLOAD=INFERENCE -DDNNL_ENABLE_PRIMITIVE="CONVOLUTION;REORDER" .
# cmake --build . --config Debug --target install --parallel 2

cd ..
rm -r oneDNN-*

mkdir build
cd build

# Release build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/Release -DCMAKE_PREFIX_PATH="C:/Program Files (x86)/Intel/oneAPI/compiler/latest/windows/compiler/lib/intel64_win;C:/oneDNN/Release" -DBUILD_CLI=OFF -DWITH_DNNL=ON ..
cmake --build . --config Release --target install --parallel 2 --verbose

# Debug build
# cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/Debug -DCMAKE_PREFIX_PATH="C:/Program Files (x86)/Intel/oneAPI/compiler/latest/windows/compiler/lib/intel64_win;C:/oneDNN/Debug" -DBUILD_CLI=OFF -DWITH_DNNL=ON ..
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=$ROOT_DIR/outputs/Debug -DBUILD_CLI=OFF -DWITH_DNNL=OFF ..
cmake --build . --config Debug --target install --parallel 2 --verbose
