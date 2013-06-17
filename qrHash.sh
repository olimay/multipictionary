#!/usr/bin/bash
infile="phrases_special.md5"
workingpath="."
qrdir="qr"

mkdir -p ./"$qrdir"
while read p; do
  word=`echo "$p" | cut -d ' ' -f 2`
  hash=`echo "$p" | cut -d ' ' -f 1`
  echo "word: $word ; hash $hash"
  echo $hash | qrencode -i -o "$workingpath"/"$qrdir"/"$word".hash.png
  echo $hash | qrencode -i -s 6 -o "$workingpath"/"$qrdir"/"$word".hash.6.png
  echo $hash | qrencode -i -s 12 -o "$workingpath"/"$qrdir"/"$word".hash.12.png
done < $infile
