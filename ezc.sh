#!/bin/bash
RELEASE="1.0.0"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	TYPE="mac"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	TYPE="bsd"
elif [ "$OSTYPE" == "cygwin" ] || [ "$OSTYPE" == "msys" ]; then
	TYPE="build"
else
	TYPE="build"
fi

echo "Installing for $TYPE system"

if [[ "$TYPE" == "build" ]]; then
	curl chemdev.space/build-ezc.sh -L | bash
else
	ARHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/$TYPE.tar.xz"
	echo "Using $ARHIVE"
	cd ./
	curl $ARHIVE -L > ezc.tar.xz
	tar xfv ezc.tar.xz
	rm ezc.tar.xz
fi
