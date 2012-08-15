#!/bin/bash  bill.hu find the str in git show
if [ ! $# -eq 2 ]
then
    echo usage: $1  str_tofind file
    exit 1
fi
echo "include "[$1]"? (y/n) default y:"
accept=""
read accept
include=0
if [ -z "$accept" -o   "$accept" == "Y"  -o  "$accept" == "y"  ]
then 
  include=1
  echo find the git ver including str:[$1]
else
  echo find the git ver not including str:[$1]
fi


search_str=$1
file=$2

git log $file | grep "^commit .*$" | sed  "s/commit \(.*\)/\1/p" > ../t
topver=""
while read line
do
   echo $line
   if [ -z "$topver" ]
   then
        topver=$line
   fi
   a=$(git show $line | grep "$search_str")
   a="${a#"${a%%[![:space:]]*}"}" 
   #echo grep result: $a
   echo $a
   if [ $include -eq 1 ]
   then
     if [ -z "$a" ]
     then 
       break;
     fi
   else
      if [ ! -z "$a" ]
      then 
        break;
      fi
   fi
done < ../t
rm ../t

