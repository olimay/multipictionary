#!/bin/bash

infile=
outfile=
revfile=

if [ -n "$1" ]; then
  infile="$1"

  if [ -n "$2" ]; then
    outfile="$2"
  else
    infile_basename=`basename "$infile"`
    outfile=`dirname "$infile"`"/${infile_basename%.*}.md5"
    revfile=`dirname "$infile"`"/${infile_basename%.*}_rev.md5"
  fi
else
  echo "No input file specified."
  exit 1
fi

echo "" > "$outfile"
echo "" > "$revfile"

echo "Reading $infile"
cd "$workingdir"
while read p; do
  # use reversed format
  md5 -s "$p" | sed 's/MD5 (//;s/) =//;s/"//g'
  md5 -r -s "$p" | sed 's/"//g' >> "$outfile"
  md5 -s "$p" | sed 's/"//g' >> "$revfile"
done < "$infile"
echo `wc -l "$outfile" | sed 's/^[ \t]*//;s/[ \t]*$//'  | cut -d ' ' -f 1` " hashes generated in $outfile"
echo `wc -l "$revfile" | sed 's/^[ \t]*//;s/[ \t]*$//'  | cut -d ' ' -f 1` " reversed in $revfile"
exit 0

