#!/bin/zsh

DIR="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
FORTUNES_DIR="/usr/local/share/games/fortunes"

cd $DIR;

for file in `find . -type f ! -name "*.*"`; do
  STR=${file:t}
  cp $DIR/$STR $FORTUNES_DIR;
  strfile $FORTUNES_DIR/$STR $FORTUNES_DIR/$STR.dat;
done;

echo "\nDone!"
