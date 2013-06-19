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

while read word; do
  echo "$word :"
  echo "$word" | qrencode -i -o "$qrdir/$word.word.png"
  echo "> $qrdir/$word.word.png"
  echo "$word" | qrencode -i -s 6 -o "$qrdir/$word.word.6.png"
  echo "> $qrdir/$word.word.6.png"
  echo "$word" | qrencode -i -s 12 -o "$qrdir/$word.word.12.png"
  echo "> $qrdir/$word.word.12.png"
done < "$infile"

