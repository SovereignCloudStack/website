#!/bin/bash
# Simple script to grep through HTML
# tracking down dependencies from the same site
# and recursively genrating a dependency file for make
#
# Limitations: We don't really parse HTML ...
# - Don't put more than one href or img src into one line
# - Use http[s] linke if you want deps to be considered external
# - Hardcode source -> build transfer of files
#
# Author: Kurt Garloff <garloff@osb-alliance.com>
# Copyright: 7/21, OSB Alliance e.V.
# SPDX-License-Identifier: CC-BY-SA-4.0

declare -i ERR=0
NAMES="$@"
COLLECTEDNM="$@"
while test -n "$NAMES"; do
NEWNM=""
for name in $NAMES; do
	SRC=${name/build/source}
	if test ! -r "$SRC"; then echo "ERROR: File $SRC does not exist"; let ERR+=1; continue; fi
	echo -n "${name}: $SRC"
	HREFS=$(grep -i 'href=' $SRC | grep -v '\(http\|mailto\|tel\)' | grep -vi 'href="/"' | grep -v '^ *<!--' | sed 's/^.*[hH][rR][Ee][fF]="\([^"]*\)".*$/\1/g')
	IMGS=$(grep -i 'src=' $SRC | grep -v http | sed 's/^.*[sS][rR][cC]="\([^"]*\)".*$/\1/g')
	FONTS=$(grep -i 'url(' $SRC | grep -v http | sed "s/^.*url('\([^']*\)').*\$/\1/")
	# Determine relative path of target file
	RNM=${name#build/}; RPTH=${RNM%/*}; if test "$RPTH" = "$RNM"; then RPTH=""; fi
	RPTH="${RPTH/\/css/}"; RPTH="${RPTH/css/}"
	for i in $HREFS $IMGS $FONTS; do
		# Fix relative paths
		if test -n "$RPTH"; then
			if [[ "$i" == /* ]]; then let nothing=0
			# FIXME: This only works for one level of subdirectories
			#elif [[ "$i" == ../* ]]; then i="${i#..}"
			else i="$RPTH/$i";
			fi
		fi
		echo -n " build/$i"
		if [[ "$i" == *.html ]] || [[ "$i" == *.html.de ]] || [[ "$i" == *.html.en ]] || [[ "$i" == *.css ]]; then
			declare -i fnd=0
			for n in $COLLECTEDNM; do if [ "build/$i" = "$n" ]; then let fnd+=1; fi; done
			if [ $fnd == 0 ]; then NEWNM="${NEWNM} build/$i"; fi
		fi
	done
	echo
done
NAMES="$NEWNM"
COLLECTEDNM="$COLLECTEDNM $NAMES"
done
exit $ERR
