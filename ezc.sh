#!/bin/sh
#RELEASE="1.2.3"
RELEASE="master"

UNAMESTR=$(uname)

echo $UNAMESTR

case "$UNAMESTR" in
	"Linux") TYPE="linux";;
	"darwin"*) TYPE="mac";;
	*"BSD") TYPE="bsd";;
	*) TYPE="build";;
esac

TYPE="build"

echo "Installing for $TYPE system"

#USE_GIT="true"

LOCATION=~/.ezc/
BUILD_DIR=$LOCATION/REPO
PROFILE=~/.bashrc
PROFILE_RELOAD="export PATH=\$PATH:${LOCATION}"
mkdir -p ${LOCATION}
cd ${LOCATION}

echo "${PROFILE_RELOAD}" >> ${PROFILE}

if [ "$TYPE" = "build" ]; then
	mkdir -p $BUILD_DIR
	cd $BUILD_DIR
	if [ "$USE_GIT" = "true" ]; then 
		git clone https://github.com/ChemicalDevelopment/ezc.git
		cd ezc
	else
		ARCHIVE="https://github.com/ChemicalDevelopment/ezc/archive/$RELEASE.tar.gz"
		echo "Using $ARCHIVE"
			curl $ARCHIVE -L > ezc.tar.gz
		tar -xvzf ezc.tar.gz
		cd ezc-*
	fi

	make DIR=$LOCATION
	rm ezc.tar.gz

	cd $LOCATION
	rm -rf $BUILD_DIR
else
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/ezc-$TYPE.tar.xz"
	echo "Using $ARCHIVE"
	
	curl $ARCHIVE -L > ezc.tar.xz
	tar -xfv ezc.tar.xz

	rm ezc.tar.xz
fi
