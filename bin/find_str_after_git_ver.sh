#!/bin/bash  bill hu,find the str in a file
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

old_branch=$(git branch | sed -n "s/^\* \(.*\)$/\1/p")

if [ "$old_branch" == "(no branch)" ]
then 
  git checkout -b git_find_str
fi

search_str=$1
file=$2

git log | grep "^commit .*$" | sed  "s/commit \(.*\)/\1/p" > ../t
topver=""
while read line
do
   echo $line
   if [ -z "$topver" ]
   then
        topver=$line
   fi
   #if [ $line = $2 ]
   #then
   #     break;
   #fi
   git checkout $line
   a=$(grep $search_str $file)
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
if [ "$old_branch" == "(no branch)" ]
then
   git checkout git_find_str
   git checkout $top_ver
   git branch -D git_find_str
else
   git checkout $old_branch
fi
rm ../t

