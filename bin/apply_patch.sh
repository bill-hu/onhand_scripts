#!/usr/bin/env python 
#coding=utf-8
#Bill hu 2013.7.29 use git am to apply all the pathes in device/amlogic/xxxx/patch
import sys,os
import shutil
import filecmp
import time
import string
import types
from glob import glob,iglob
from os.path import walk, join, normpath
from string import strip
targetpath=""
product=""
cwd=""
gitdir=""
repodir=""
pathspliter="/"
patchcommitdir=""
cmd_arg=0;
failedgit=["",]
input_cmd=""
git_config_name=["core.whitespace","apply.whitespace"]
git_config_value=["trailing-space,space-before-tab","fix"]
git_config_keepvalue=["",""]


def get_git_config(name,value):
    cmd="git config --global --get "+name
    ret=os.popen(cmd).readlines()
    if len(ret)>=1:
       oldvalue=strip(ret[0])
       if oldvalue == value :
            return ""
       else:
            return oldvalue
    return value

def get_all_git_config():
    for i in range(0,len(git_config_name)):
        git_config_keepvalue[i]=get_git_config(git_config_name[i],git_config_value[i])
        if git_config_keepvalue[i]!=git_config_value[i] and git_config_keepvalue[i]!= "":
            cmd="git config --global --unset "+git_config_name[i]+" "+git_config_keepvalue[i]
            os.system(cmd)
        if git_config_keepvalue[i]==git_config_value[i] or git_config_keepvalue[i]!= "":
            cmd="git config --global --add "+git_config_name[i]+" "+git_config_value[i]
            os.system(cmd)

def restore_all_git_config():
    for i in range(0,len(git_config_name)):
        if git_config_keepvalue[i]!="" and git_config_keepvalue[i]!=git_config_value[i]:
            cmd="git config --global --unset "+git_config_name[i]+" "+git_config_value[i]
            os.system(cmd)
            cmd="git config --global --add "+git_config_name[i]+" "+git_config_keepvalue[i]
            os.system(cmd)

def getpatchfile(arg, dirname, names):
     for name in names:
         if(name.endswith('.patch')):
             do_apply(dirname,name)
             return 0;
     return 0

def do_apply(patchdir,patchfile):
    print ""
    gitdir=repodir+get_relative_dir(patchcommitdir,patchdir)
    print gitdir
    patchname=patchdir+pathspliter+"*.patch"
    os.chdir(gitdir)
    if( cmd_arg ==1):
        return 0
    elif ( cmd_arg ==2):
        cmd="git am --abort"
        os.system(cmd)
        return 1
    elif ( cmd_arg ==3):
        os.system(input_cmd)
        return 1
    elif (cmd_arg !=0):
        return -1
    print "------------Begin apply patch:"
    print patchcommitdir
    print patchdir
    cmd="git am "+patchname
    print cmd
    ret=os.popen(cmd).readlines();
    failed=False
    for line in ret:
        print line
        if line.startswith("Patch failed"):
            print "---------Error happened while apply patch,git am aborted"
            os.system("git am --abort")
            failed=True
            break
    if failed==False:
        print "------------Finished make patch in "+gitdir
    return 0

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

def get_relative_dir(parent,sub):
    return sub[len(parent):len(sub)]

def useage():
       print "Useage:"
       print sys.argv[0]+" apply  :apply the patches"
       print sys.argv[0]+" list   :list the git folders need be patched"
       print sys.argv[0]+" abort  :abort the unfinished patch apply"
       print sys.argv[0]+" cmd <\"shell command\">  :execute the shell command in each git folder need be patched"

if len(sys.argv) >=2:
    if(sys.argv[1] == "list"):
       cmd_arg=1
    elif(sys.argv[1] == "abort"):
       cmd_arg=2
    elif(sys.argv[1] == "cmd"):
       cmd_arg=3
       if len(sys.argv)<3:
          print "cmd must be given after cmd"
          exit(-2)
       input_cmd=sys.argv[2]
       print "input_cmd: "+input_cmd
    elif sys.argv[1]!="apply":
       useage()
       exit(-1)
else:
   useage()
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

patchcommitdir=get_patch_commit_dir()
print "patch Root:"+patchcommitdir
if cmd_arg==0:
   get_all_git_config()
walk(patchcommitdir,getpatchfile,0)
if cmd_arg==0:
   restore_all_git_config()
   print "finish!\n"
print ""
