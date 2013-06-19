#!/bin/bash


#!/bin/bash

infile=

if [ -n "$1" ]; then
  infile="$1"

  if [ -n "$2" ]; then
    qrdir="$2"
  else
    qrdir=`dirname $infile`"/qr"
  fi
else
  echo "No input file specified."
  exit 1
fi

mkdir -p "$qrdir"

while read p; do
  word=`echo "$p" | cut -d ' ' -f 2`
  hashcode=`echo "$p" | cut -d ' ' -f 1`
  echo "word: $word ; hash: $hashcode"
  echo $hashcode | qrencode -i -o "$qrdir/$word.hash.png"
  echo $hashcode | qrencode -i -s 6 -o "$qrdir/$word.hash.6.png"
  echo $hashcode | qrencode -i -s 12 -o "$qrdir/$word.hash.12.png"
done < $infile
