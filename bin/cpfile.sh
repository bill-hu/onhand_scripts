#!/usr/bin/env python 
#cording=utf-8
#Bill hu 2011.6 backup modified or none git project files.useage: repo status >t; back_amf.sh t ../yourbackupfolder
import sys,os
import shutil
import filecmp
from os.path import walk, join, normpath
targetpath=""
srcpath=""
backuppath=""
identifier="--"
identifier_m="-m"
filename=""

if len(sys.argv) <3:
     print "Usage: "+sys.argv[0]+" FileListFile_toread destpath"
     exit(-1)
if not os.path.isfile(sys.argv[1]):
     print "file:"+sys.argv[1]+"not exist"
     exit(-2)
if not os.path.exists(sys.argv[2]):
     print "dest path '"+ sys.argv[2] + "' not exist,create it?(Y/n)"
     r=raw_input()
     if  r== "Y" :
          os.mkdir(sys.argv[2])
          if not os.path.exists(sys.argv[2]):
                  print "Create path '"+ sys.argv[2] + "' fail"
                  exit (-3)
     else: 
          exit (-4)
targetpath = sys.argv[2]
if not targetpath.endswith("/"):
     targetpath = targetpath + "/"
print "target path is " + targetpath
fobj = file(sys.argv[1])
lines = fobj.readlines()
folder=""
for line in lines:
    line=line.strip()
    print line
    srcfile=line
    targetfile=targetpath + srcfile
    filepath= os.path.dirname(targetfile)
    if not os.path.exists(filepath):
             os.makedirs(filepath)
    print "src: "+ srcfile
    print "-->dest: " + targetfile
    shutil.copy2(srcfile,targetfile)

