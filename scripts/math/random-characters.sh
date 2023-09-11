#!/usr/bin/sh
# random-characters.sh
printf " \$ti";
read pngs</dev/urandom;
pc=1;
while [ $pc -le $(((${#pngs}%5)+8)) ]; do
  read s s2</dev/urandom;
  printf "\n\n";
  printf `printf "\\%o" "$(((${#s}%26)+65))"`;
  printf `printf "\\%o" "$(((${#s2}%26)+97))"`;
  l=${#s};
  i=1;
  while [ $i -le $l ]; do
    c=`printf %c "${s%${s#?}}"`;
    s=${s#?};
    cc=`printf %d \`printf "\047$c" 2>&-\``;
    printf `printf "\\%o" "$((((cc+i)%95)+32))"`;
    i=$((i+1));
  done;
  pc=$((pc+1));
done;
