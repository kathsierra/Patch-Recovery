#!/bin/bash
set -e

mkdir -p unpack
cd unpack

# Just unpack and repack without patching
../magiskboot unpack ../recovery.img
../magiskboot repack ../recovery.img new-boot.img

cp new-boot.img ../recovery-patched.img
