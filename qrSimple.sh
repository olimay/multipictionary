mkdir -p ./qr
while read p; do
  echo $p | qrencode -i -o ./qr/"$p".word.png
  echo $p | qrencode -i -s 6 -o ./qr/"$p".word.6.png
  echo $p | qrencode -i -s 12 -o ./qr/"$p".word.12.png
done < phrases_simple.txt
