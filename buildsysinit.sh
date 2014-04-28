#!/bin/bash

targets=("$@")

#This should be equivalent to $WORKSPACE/builder in Jenkins
TMPCURDIR=$( cd "$( dirname "$0" )" && pwd )
echo $TMPCURDIR

cd $TMPCURDIR/..
if ls | grep buildsys; then
	echo "Build environment previously created. Updating..."
else
	echo "Creating new build environment"
	mkdir buildsys
fi
cd buildsys


#Get all updated repos
if  ls | grep oe-core; then
	cd oe-core && git pull origin master && cd ..
else
	git clone https://github.com/openembedded/oe-core.git
fi

if ls | grep meta-oe; then
	cd meta-oe && git pull origin master && cd ..
else
	git clone https://github.com/openembedded/meta-oe.git
fi

if ls | grep meta-raspberrypi; then
	cd oe-core && git pull origin master && cd ..
else
	git clone https://github.com/djwillis/meta-raspberrypi.git
fi

if ls | grep meta-twitter; then
	cd meta-twitter && git pull origin master && cd ..
else
	git clone https://github.com/petermuller/meta-twitter.git
fi

if ls | grep meta-tarsals; then
	cd meta-tarsals && git pull origin master && cd ..
else
	git clone https://github.com/petermuller/meta-tarsals.git
fi

cd oe-core
COREDIR=$(pwd)
if ls | grep bitbake; then
	cd bitbake && git pull origin master && cd ..
else
	git clone https://github.com/openembedded/bitbake.git
fi

#For building in Jenkins
if [[ -n "$WORKSPACE" ]]; then
	unset HOME
	export HOME="$WORKSPACE"
fi

#Update settings
#BUILDDIR gets defined in the source command
source oe-init-build-env
cp -v $TMPCURDIR/local.conf $BUILDDIR/conf/local.conf
cp -v $TMPCURDIR/bblayers.conf $BUILDDIR/conf/bblayers.conf
bitbake -c clean rpi-tarsals-image


#for (( i=0; i<"$#"; i++ ))
#do
#	cd $COREDIR
#	source oe-init-build-env
#	if [[ "${targets[i]}" == "clean" ]]; then
#		bitbake -c clean "${targets[i+1]}"
#	else
#		bitbake "${targets[i]}"
#	fi
#done
