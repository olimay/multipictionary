#!/bin/bash

# makes sure the challenge word is in one of the
# words.txt files
# input: words in challenges, one per line

while read line; do
  results=`grep -x "$line" *_words.txt`
  if [ -z "$results" ]; then
    echo "> no results for $line"
  fi
done
