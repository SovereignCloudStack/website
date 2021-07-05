#!/bin/bash

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
	for i in $HREFS $IMGS; do 
		echo -n " build/$i"
		if [[ "$i" == *.html ]] || [[ "$i" == *.html.de ]] || [[ "$i" == *.html.en ]]; then
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
