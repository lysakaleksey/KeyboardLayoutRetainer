#/bin/bash

rm -rf build
rm -rf DerivedData
xcodebuild

killall KeyboardLayoutRetainer
rm -rf /Applications/KeyboardLayoutRetainer.app
cp -R ./build/Release/KeyboardLayoutRetainer.app /Applications
