#!/bin/bash

LRNDIR='/home/dos/git/learning/'
cd $LRNDIR

pushd "${LRNDIR}networking_for_the_youngest"
mv -vb ~/pt/saves/* .
popd
packettracer &

code ${LRNDIR}cheatsheets/ &

echo "$LRNDIR"
