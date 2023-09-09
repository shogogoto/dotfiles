#!/bin/bash


folder=$1
pushd $1

ls | while read line
do
  echo --------------
  to="../${folder}_${line}"
  echo from:$line
  echo to:"$to"
  mv "$line" "${to/-/_}"
done

popd
# rm -r $folder
