#!/bin/sh

###
# ChemicalDevelopment c 2017.
#
# This install script, and the program it is installing, is free software, licensed under the GPLv3.
# You are free to copy, modify, redistribute, and all everything else permitted under the GPLv3.
#
# EZC POSIX Install Script
#
# Meant to work with /bin/sh, or any other POSIX compliant shell.
# Tools needed:
#   python - included with bundled versions (for BSD)
#   cc - any full style C compiler. tcc will work for built versions, however, a full C compiler is needed for GMP/MPFR
#        also, macOS bundled versions include tcc
#   basic utils - shell utilities, realpath, curl, tar, etc. Should come with BSD/macOS/Linux
#
# Running:
#   To install default, download this script (located at chemdev.space/ezc/install.sh), and then run with sh:
#   `sh install.sh`
#
#   However, you can also set where to install to. see http://chemicaldevelopment.us/ezc/#/installing for more
#
###



echo "You entered:"
echo "  VERSION: $VERSION"
echo "  PATHFILE: $PATHFILE"
echo "  LOCATION: $LOCATION"
echo "  PLATFORM: $PLATFORM"
echo ""

if [ "$VERSION" = "" ]; then
	VERSION="1.4.1"
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
	UNAMESTR=$(uname -s)
	ARCHSTR=$(uname -m)

	echo $UNAMESTR

	case "$UNAMESTR" in
		"Linux") PLATFORM="linux";;
		"Darwin") PLATFORM="mac";;
		*"BSD") PLATFORM="bsd";;
		*) PLATFORM="build";;
	esac
	PLATFORM="${PLATFORM}-${ARCHSTR}"
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
sh -c "${PATHFILE_RELOAD}"


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

