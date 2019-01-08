#!/usr/bin/python
#coding:utf-8
import os,sys
root_path = ''
git_list_file = ''
fd_git_list_file = None
def get_git(path):
    print path
    abs_path = root_path + path[1:]
    print abs_path
    cwd = os.getcwd()
    os.chdir(abs_path)
    fd_git_list_file.write(path)
    fd_git_list_file.write('|')
    rev = os.popen("git rev-list HEAD -n 1")
    print rev
    fd_git_list_file.write(rev.read())
    os.chdir(cwd)
     


def process_path(level, path):
    dirList = []
    files = os.listdir(path)
    dirList.append(str(level))
    for f in files:
        if(os.path.islink(path + '/' + f)):
            continue

        if(os.path.isdir(path + '/' + f)):
            if(f[0] == '.'):
                if(f == '.git'):
                    get_git(path)
            else:
                dirList.append(f)
    i_dl = 0
    for dl in dirList:
        if(i_dl == 0):
            i_dl = i_dl + 1
        else:
            process_path((int(dirList[0]) + 1), path + '/' + dl)

if __name__ == '__main__':
    root_path = os.getcwd()
    git_list_file = root_path + "/git_list.txt"
    fd_git_list_file = open(git_list_file, 'w')
    process_path(1, '.')
    fd_git_list_file.close()
