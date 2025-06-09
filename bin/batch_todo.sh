#!/bin/bash

for file in $@; do
  cat $file | while IFS= read -r line; do
    echo "$line" | xargs todo.sh add
  done
done
