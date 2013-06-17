#!/usr/bin/bash

infile=phrases_special.txt
outfile=phrases_special.md5
while read p; do
  md5 -r -s "$p"
  md5 -r -s "$p" >> $outfile 
done < phrases_special.txt
wc -l $outfile 
