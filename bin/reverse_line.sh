#!/bin/bash
# hubin 2012
declare -a buf
declare -i i
i=0
while read line
do
   echo $line
   buf[i]=$line
   i=i+1
done < a
echo "\n"
for ((j=$i-1;j>=0;j --))
do
   ver=${buf[j]}
   echo $ver >> b
  
done
