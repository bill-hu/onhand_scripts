#/bin/bash cp android jars to ~/jar  bill.hu 2012.8.1
target=$HOME"/jar"
if [ ! -d "$target" ]
then 
    mkdir "$target"
fi
out="out/target/common/obj/JAVA_LIBRARIES"
if [ ! -d "$out" ]
then
  echo folder $out not exist
  exit 0 
fi
find "$out" -name "classes.jar" > a
while read line
do
echo $line
     name=${line%%_inter*}
     name=${name##*/}
     name=$HOME'/jar/'$name'.jar'
     echo $name
     cp $line $name
done < a
