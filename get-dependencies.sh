#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm python

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of DOSBox Pure Unleashed..."
echo "---------------------------------------------------------------"
REPO="https://github.com/schellingb/dosbox-pure-unleashed"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO"
echo "$VERSION" > ~/version
git clone https://github.com/schellingb/dosbox-pure
git clone https://github.com/schellingb/ZillaLib

mkdir -p ./AppDir/bin
cd dosbox-pure-unleashed
make linux-release ZL_VIDEO_OPENGL_CORE=1 -j"$(nproc)"
mv -v ./Release-linux/DOSBoxPure_* ../AppDir/bin/DOSBoxPure
