#!/usr/bin/bash
infile="phrases_special.txt"
while read p; do
  echo $p
done < $infile 
