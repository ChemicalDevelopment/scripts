#!/bin/sh
RELEASE="1.2.3"

UNAMESTR=$(uname)

echo $UNAMESTR

case "$UNAMESTR" in
	"Linux") TYPE="linux";;
	"darwin"*) TYPE="mac";;
	*"BSD") TYPE="bsd";;
	*) TYPE="build";;
esac

echo "Installing for $TYPE system"

if [ "$TYPE" = "build" ]; then
	curl chemdev.space/build-ezc.sh -L | bash
else
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/ezc-$TYPE.tar.xz"
	echo "Using $ARCHIVE"
	LOCATION=~/.ezc/
	PROFILE=~/.bashrc
	PROFILE_RELOAD="export PATH=\$PATH:${LOCATION}"
	mkdir -p ${LOCATION}
	cd ${LOCATION}

	curl $ARCHIVE -L > ezc.tar.xz
	tar xfv ezc.tar.xz

	echo "${PROFILE_RELOAD}" >> ${PROFILE}
	rm ezc.tar.xz
	exit 0;

fi
