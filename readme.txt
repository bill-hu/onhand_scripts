adb related scripts
1.adbc
. adbc 10.68.12.102
this will connect to 10.68.12.102:5555,and export ADB_SERVER_IP=10.68.12.102 for furthur usage

2.adbd
. adbd 10.68.12.102
this will disconnect 10.68.12.102:5555,and export ADB_SERVER_IP without any string

3.a 
this is same as adb -s 10.68.12:5555 %1 %2 %3 %4
for example,if you want to do adb push xxx.apk /system/app
you need type:a push xxx.apk /system/app

4.c
some times,adb connection will disconnect,then you should reconnect
adb connect $ADB_SERVER_IP

5.backup_git.pl
back up all the git in a folder to another folder
------------------------------------
git related:
------------------------------------
mount_smbdir.sh : 
example of mount a smb dir to local dir 57

