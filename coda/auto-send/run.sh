#!/bin/bash
for i in $(seq 1 1000)
do
  ./send_ECHO_script.sh $i &
  sleep 3
  echo $i
done
