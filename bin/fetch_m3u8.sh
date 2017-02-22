#!/bin/bash
#fetch m3u8

echo fetching: $1
OLD_IFS="$IFS" 
IFS="/"
array=($1) 
IFS="$OLD_IFS" 


num=${#array[@]} 

echo $num

m3u8=${array[num-1]}
folder=${array[num-2]}

mkdir $folder
cd $folder
path=""
for ((i=0;i<num-1;i++))
{
	path=$path${array[i]}"/"
}

echo $path

curl $1 -o $m3u8
grep ts $m3u8 |while read LINE
do
    echo fetching: $path$LINE
	curl $path$LINE -o $LINE
done
