#!/bin/sh
RELEASE="1.2.3"

UNAMESTR=`uname`

if [ "$UNAMESTR" = "Linux" ]; then
	TYPE="linux"
elif [ "$UNAMESTR" = "darwin"* ]; then
	TYPE="mac"
elif [ "$UNAMESTR" = *"BSD" ]; then
	TYPE="bsd"
elif [ "$UNAMESTR" = "cygwin" ] || [ "$UNAMESTR" = "msys" ]; then
	TYPE="build"
else
	TYPE="build"
fi

echo "Installing for $TYPE system"

if [ "$TYPE" = "build" ]; then
	curl chemdev.space/build-ezc.sh -L | bash
else
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/ezc-$TYPE.tar.xz"
	echo "Using $ARCHIVE"
	cd ./
	curl $ARCHIVE -L > ezc.tar.xz || { echo "Building EZC from source, because I couldn't find an archive for your OS ($TYPE)"; curl chemdev.space/build-ezc.sh -L | bash; exit 0; }
	tar xfv ezc.tar.xz
	rm ezc.tar.xz
fi
