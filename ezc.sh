#!/bin/sh

echo "You entered:"
echo "  VERSION: $VERSION"
echo "  PATHFILE: $PATHFILE"
echo "  LOCATION: $LOCATION"
echo "  PLATFORM: $PLATFORM"
echo ""

if [ "$VERSION" = "" ]; then
	VERSION="1.3.1"
fi

if [ "$VERSION" = "dev" ]; then
	VERSION="master"
	PLATFORM="build"
fi

if [ "$PATHFILE" = "" ]; then
	PATHFILE=~/.bashrc
fi
if [ "$LOCATION" = "" ]; then
	LOCATION=~/.ezc/
fi

if [ "$PLATFORM" = "" ]; then
	UNAMESTR=$(uname)

	echo $UNAMESTR

	case "$UNAMESTR" in
		"Linux") PLATFORM="linux";;
		"darwin"*) PLATFORM="mac";;
		*"BSD") PLATFORM="bsd";;
		*) PLATFORM="build";;
	esac
fi

echo "Actually using:"
echo "  VERSION: $VERSION"
echo "  PATHFILE: $PATHFILE"
echo "  LOCATION: $LOCATION"
echo "  PLATFORM: $PLATFORM"
echo ""

BUILD_DIR=$LOCATION/REPO
PATHFILE_RELOAD="export PATH=\$PATH:${LOCATION}"
mkdir -p ${LOCATION}
cd ${LOCATION}

echo "${PATHFILE_RELOAD}" >> ${PATHFILE}

if [ "$PLATFORM" = "build" ]; then
	mkdir -p $BUILD_DIR
	cd $BUILD_DIR
	if [ "$USE_GIT" = "" ]; then 
		ARCHIVE="https://github.com/ChemicalDevelopment/ezc/archive/$VERSION.tar.gz"
		echo "Using $ARCHIVE"
		curl $ARCHIVE -L > ezc.tar.gz
		tar -xzf ezc.tar.gz
		cd ezc-*
	else
		git clone https://github.com/ChemicalDevelopment/ezc.git
		cd ezc
		if [ "$VERSION" != "master" ]; then
			git checkout tags/$VERSION
		fi
	fi

	make DIR=$LOCATION
	rm ezc.tar.gz

	cd $LOCATION
	rm -rf $BUILD_DIR
else
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$VERSION/ezc-$PLATFORM.tar.xz"
	echo "Using $ARCHIVE"
	
	curl $ARCHIVE -L > ezc.tar.xz
	tar -xf ezc.tar.xz

	rm ezc.tar.xz
fi

