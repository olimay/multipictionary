#!/bin/bash

infile=

if [ -f "$1" ]; then
  infile="$1"
elif [ -d "$1" ]; then
  echo "$1 is a directory"
  exit 1
elif [ ! -f "$1" ]; then
  echo "Could not open file $1"
  exit 1
else
  echo "Usage modHash [hashfile]"
  exit 1
fi

count=0

while read p;
do
  
  lasthex=`echo "$p" | cut -d ' ' -f 1 | colrm 1 31` 
  # echo "$count hex($lasthex)"
  hexcode="0x$lasthex"
  word=`echo "$p" | cut -d ' ' -f 2`
  modcode=`printf '%d' "$hexcode"`
  echo "$modcode $word"
  count=$[count+1]
done < "$infile"
