#!/bin/bash

NAME='Desnes'

#CENTOS 7 
SPEC7="https://git.centos.org/rpms/kernel/raw/c7/f/SPECS/kernel.spec"

#CENTOS 8
SPEC8="https://git.centos.org/rpms/kernel/raw/c8/f/SPECS/kernel.spec"

#CENTOS 9
SPEC9="https://git.centos.org/rpms/kernel/raw/c9/f/SPECS/kernel.spec"

echo
echo "#########################"
echo "# CENTOS COMMIT FETCHER #"
echo "#########################"
echo

function get_commits()
{
	local URL=$1
	local VERSION=$2
	
	pushd /tmp/ &> /dev/null

	SPEC=$(mktemp /tmp/spec.XXXXXX)

	echo -n "Downloading CentOS$VERSION's kernel spec file ... "
	wget -q $URL -O $SPEC
	echo "done"

	echo -n "Finding your CentOS$VERSION commits ... "
	sed -i -n -e '/^%changelog/,$p' $SPEC
	sed -i '/^%changelog/d' $SPEC

	case ${URL} in
		*7*)
			FILENAME="/tmp/commits-from-$NAME-centos7.txt"
		;;
		*8*)
			FILENAME="/tmp/commits-from-$NAME-centos8.txt"
		;;
		*9*)
			FILENAME="/tmp/commits-from-$NAME-centos9.txt"
		;;
	esac;

	grep "$NAME" $SPEC > $FILENAME 

	echo "done"

	echo "Fetch your CentOS$VERSION commit file at $FILENAME"
	echo "You have $(cat $FILENAME | wc -l) contributions to CentOS$VERSION"
	echo

	popd &> /dev/null
}

get_commits $SPEC7 7
get_commits $SPEC8 8
get_commits $SPEC9 9

exit 0
