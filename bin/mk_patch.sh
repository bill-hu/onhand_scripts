#!/usr/bin/env python 
#coding=utf-8
#Bill hu 2013.7 do patch,cp top patch to device/amlogic/xxxx/patch,and pathch/bugnum/
import sys,os
import shutil
import filecmp
import time
import string
import types
from glob import glob,iglob
targetpath=""
filename=""
product=""
cwd=""
gitdir=""
repodir=""
pathspliter="/"
index=0
bugnumber=""
patchcommitdir=""
patchreleasedir=""
patchsrcreleasedir=""
patchcommit="HEAD"

def get_date_str():
    return time.strftime('%Y-%m-%d',time.localtime(time.time()))

def find_in_parent(curpath,path):
    if os.path.isdir(curpath+pathspliter+path) is True :
        return curpath
    
    while True:
          index=curpath.rfind(pathspliter)
     
          if(index>0):
              curpath=curpath[0:index]
          else:
              return ""
          if os.path.isdir(curpath+pathspliter+path) is True:
              return curpath

def get_patch_commit_dir():
    return repodir+pathspliter+"device/amlogic/"+product+pathspliter+"patch"

def get_patch_release_dir():
    return repodir+pathspliter+"patch"+pathspliter+bugnumber

def get_commit_files(commit):
    cmd="git show "+commit+" | sed -n \"s/+++ b\\///p\""
    ret=os.popen(cmd).readlines();
    return ret

def get_relative_dir(parent,sub):
    return sub[len(parent):len(sub)]

def get_relative_dir_str(parent,sub):
    return sub[len(parent):len(sub)].replace(pathspliter,"-")

def cp_file_to_releasedir(filename):
    targetfile=patchsrcreleasedir+pathspliter+filename
    pathindex=targetfile.rfind(pathspliter)
    targetpath=targetfile[0:pathindex]
    if not os.path.exists(targetpath):
       os.makedirs(targetpath)
    print "Copying:"+targetfile
    shutil.copy2(filename,targetfile)

def make_patch(commit,filename):
    patchcommitfile=patchcommitdir+pathspliter+filename;
    cmd="git show "+commit+">"+ patchcommitfile;
    print "Writing Patch:"+patchcommitfile
    os.system(cmd)
    destfile=patchreleasedir+pathspliter+filename
    print "Writing Patch:"+destfile
    shutil.copy2(patchcommitfile,destfile)
   
print ""
if len(sys.argv) <2:
     print "Usage: "+sys.argv[0]+"   bugnumber"
     exit(-1)
product=os.environ.get('TARGET_PRODUCT')
if type(product) is types.NoneType:
    print "TARGET_PRODUCT not exported"
    exit(-3)
cwd=os.getcwd();
repodir=find_in_parent(cwd,".repo")
if(repodir==""):
   print "can't find .repo in parent dir"
   exit(-4)
print "Android Root:"+repodir
gitdir=find_in_parent(cwd,".git")
if(gitdir==""):
   print "can't find .git in parent dir"
   exit(-5)
print "Git Root:"+gitdir
if(gitdir!= cwd):
   os.chdir(gitdir)

git_relative_dir_str=get_relative_dir_str(repodir,gitdir)
bugnumber=sys.argv[1]
patchreleasedir=get_patch_release_dir()
patchsrcreleasedir=patchreleasedir+get_relative_dir(repodir,gitdir)
patchcommitdir=get_patch_commit_dir()
patchprefix=get_date_str()+"-"
filetofind=patchcommitdir+pathspliter+patchprefix+"??*"
lenprefix=len(filetofind)
patchindex=1
files=iglob(filetofind)
for name in files:
     lastindex=name[lenprefix-3:lenprefix-1].strip("- ")
     tmpindex=string.atoi(lastindex)
     if(tmpindex>=patchindex):
         patchindex=tmpindex+1
if patchindex<10:
    patchprefix=patchprefix+"0"+str(patchindex)
else:
    patchprefix=patchprefix+str(patchindex)
print "\nCopy source files:"
files=get_commit_files(patchcommit)
for file in files:
    if file[len(file)-1]=='\n':
       file=file[0:len(file)-1]
    cp_file_to_releasedir(file)

patchfilename=patchprefix+"-"+bugnumber+git_relative_dir_str+".patch"
print "\nWrite patch files:"
make_patch(patchcommit,patchfilename)
print "finish!\n"
