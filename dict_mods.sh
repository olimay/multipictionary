#!/bin/bash

infile=
outfile=

if [ -n "$1" ]; then
  infile="$1"

  if [ -n "$2" ]; then
    outfile="$2"
  else
    infile_basename=`basename "$infile"`
    outfile=`dirname "$infile"`"/${infile_basename%.*}.dict"
  fi
else
  echo "No input file specified."
  exit 1
fi


tempfile="$outfile.tmp"
echo -n "" > "$outfile"
echo -n "" > "$tempfile"

echo "Reading $infile"
cd "$workingdir"
while read p; do
  mod=`echo $p | cut -d ' ' -f 1`
  word=`echo $p | cut -d ' ' -f 2`
  echo "$word $mod" >> "$tempfile"
done < "$infile"

cat "$tempfile" | sort | tee "$outfile"
