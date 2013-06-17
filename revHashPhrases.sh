#!/usr/bin/bash

while read p; do
  md5 -s "$p"
  md5 -s "$p" >> phrases_special_rev.md5
done < phrases_special.txt
wc -l phrases_special_rev.md5
