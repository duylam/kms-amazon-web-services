#!/bin/bash

function Fibonacci {
  case $1 in
    0|1) echo -n "$1 ";;
    *) echo -n "$(( $(Fibonacci $(($1-2))) + $(Fibonacci $(($1-1))) )) ";;
  esac
}

for (( i=0; i<20; i++ )) do
  Fibonacci $i > /dev/null
done