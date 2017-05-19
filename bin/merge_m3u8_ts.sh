#!/bin/bash
#fetch m3u8

echo merge: $1


grep ts total.m3u8 |while read LINE
do
    echo merging: $path$LINE
	cat $LINE >> total.ts
done
