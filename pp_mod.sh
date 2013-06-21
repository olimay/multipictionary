#!/bin/bash

while read line; do
  word=`echo "$line" | cut -d ' ' -f 1`
  mod=`echo "$line" | cut -d ' ' -f 2`
  printf "%18s %.2u\n" "$word" "$mod" 
done
