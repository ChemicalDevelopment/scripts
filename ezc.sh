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

if [ "$TYPE" != "build" ]; then
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/ezc-$TYPE.tar.xz"
	echo "Using $ARCHIVE"
	cd ./
	{
		LOCATION=~/.ezc/
		PROFILE=~/.bash_profile
		PROFILE_RELOAD=export PATH=$${PATH}:${LOCATION}
		mkdir -p ${LOCATION}
		cd ${LOCATION}

		curl $ARCHIVE -L > ezc.tar.xz
		tar xfv ezc.tar.xz

		echo "${PROFILE_RELOAD}" >> ${PROFILE}
		${PROFILE_RELOAD}
		rm ezc.tar.xz
		exit 0;
	} || {
		 echo "Building EZC from source, because I couldn't find an archive for your OS ($TYPE)"
		 TYPE="build"; 
	}
fi

if [ "$TYPE" = "build" ]; then
	curl chemdev.space/build-ezc.sh -L | bash
fi
