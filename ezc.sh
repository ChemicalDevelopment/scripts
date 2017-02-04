#!/bin/sh
#RELEASE="master"

echo "You entered:"
echo "  RELEASE: $RELEASE"
echo "  PROFILE: $PROFILE"
echo "  LOCATION: $LOCATION"
echo "  TYPE: $TYPE"
echo ""

if [ "$RELEASE" = "" ]; then
	RELEASE="1.3.1"
fi

if [ "$RELEASE" = "dev" ]; then
	RELEASE="master"
	TYPE="build"
fi

if [ "$PROFILE" = "" ]; then
	PROFILE=~/.bashrc
fi
if [ "$LOCATION" = "" ]; then
	LOCATION=~/.ezc/
fi

if [ "$TYPE" = "" ]; then
	UNAMESTR=$(uname)

	echo $UNAMESTR

	case "$UNAMESTR" in
		"Linux") TYPE="linux";;
		"darwin"*) TYPE="mac";;
		*"BSD") TYPE="bsd";;
		*) TYPE="build";;
	esac
fi

echo "Actually using:"
echo "  RELEASE: $RELEASE"
echo "  PROFILE: $PROFILE"
echo "  LOCATION: $LOCATION"
echo "  TYPE: $TYPE"
echo ""

BUILD_DIR=$LOCATION/REPO
PROFILE_RELOAD="export PATH=\$PATH:${LOCATION}"
mkdir -p ${LOCATION}
cd ${LOCATION}

echo "${PROFILE_RELOAD}" >> ${PROFILE}

if [ "$TYPE" = "build" ]; then
	mkdir -p $BUILD_DIR
	cd $BUILD_DIR
	if [ "$USE_GIT" = "" ]; then 
		ARCHIVE="https://github.com/ChemicalDevelopment/ezc/archive/$RELEASE.tar.gz"
		echo "Using $ARCHIVE"
		curl $ARCHIVE -L > ezc.tar.gz
		tar -xzf ezc.tar.gz
		cd ezc-*
	else
		git clone https://github.com/ChemicalDevelopment/ezc.git
		cd ezc
		if [ "$RELEASE" != "master" ]; then
			git checkout tags/$RELEASE
		fi
	fi

	make DIR=$LOCATION
	rm ezc.tar.gz

	cd $LOCATION
	rm -rf $BUILD_DIR
else
	ARCHIVE="https://github.com/ChemicalDevelopment/ezc/releases/download/$RELEASE/ezc-$TYPE.tar.xz"
	echo "Using $ARCHIVE"
	
	curl $ARCHIVE -L > ezc.tar.xz
	tar -xf ezc.tar.xz

	rm ezc.tar.xz
fi

