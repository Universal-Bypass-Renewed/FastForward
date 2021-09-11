#!/usr/bin/env bash
#
# This script assumes a linux environment
# Usage: chromium.sh [argument]
#  Arguments: {none} : dev package
#             nover  : Creates a package without version number
#               ver  : Creates a package with version number as specified in version.txt

set -e

echo "*** FastForward.Chromium: Creating package..."
DES=build/FastForward.chromium
DIST=build/dist
rm -rf      ./$DES
mkdir -p    ./$DES
rm -rf      ./$DIST
mkdir -p    ./$DIST

echo "*** FastForward.Chromium: Copying files"
bash ./scripts/copy_common.sh              $DES
cp platform_spec/chromium/manifest.json    $DES

cd $DES

if [[ $# -eq 0 ]]; then
    echo "*** FastForward.Chromium: Creating dev package... (Tip: Use nover to create a no-version package)"
    bash ../../scripts/version.sh manifest.json 0
    zip -qr ../$(basename $DIST)/FastForward_chromium_$(git shortlog | grep -E '^[ ]+\w+' | wc -l)_dev.zip .

elif [ "$1" == "nover" ] ; then
    echo "*** FastForward.Chromium: Creating non-versioned package... "
    rm injection_script.js
    rm rules.json
    bash ../../scripts/version.sh manifest.json nover
    zip -qr ../$(basename $DIST)/FastForward_chromium_0.$(git shortlog | grep -E '^[ ]+\w+' | wc -l).zip .

elif [ "$1" == "ver" ]; then
    echo "*** FastForward.Chromium: Creating versioned package... "
    rm injection_script.js
    rm rules.json
    bash ../../scripts/version.sh manifest.json
    zip -qr ../$(basename $DIST)/FastForward_$(cat ../../src/version.txt)_chromium.zip .

fi

echo "*** FastForward.Chromium: Package done."
