#! /bin/bash

set -e
set -x

ROOT_DIR=$PWD

mkdir outputs
mkdir outputs/include
mkdir outputs/lib

# See https://github.com/oneapi-src/oneapi-ci for installer URLs
curl -L -nv -o webimage.exe https://registrationcenter-download.intel.com/akdlm/irc_nas/19078/w_BaseKit_p_2023.0.0.25940_offline.exe
./webimage.exe -s -x -f webimage_extracted --log extract.log
rm webimage.exe
./webimage_extracted/bootstrapper.exe -s --action install --components="intel.oneapi.win.mkl.devel" --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 --log-dir=.
# Installed Location: C:\Program Files (x86)\Intel\oneAPI

cp C:/"Program Files (x86)"/Intel/oneAPI/mkl/latest/include/* $ROOT_DIR/outputs/include/
cp C:/"Program Files (x86)"/Intel/oneAPI/mkl/latest/lib/intel64/*.lib $ROOT_DIR/outputs/lib/
