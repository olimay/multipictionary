#!/bin/bash

infile="phrases_special.txt"
outfile="phrases_special_rev.md5"

while read p; do
  md5 -s "$p"
  md5 -s "$p" >> "$outfile"
done < "$infile"
wc -l "$outfile" 
