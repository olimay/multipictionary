#!/bin/bash

while read line; do
  echo "$line" | sed 's/ /|/g' | tr -s '|' '\n'
done
