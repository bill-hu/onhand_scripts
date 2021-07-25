REM use usr/bin of git bash 
git status | grep modified: | awk '{print $2}' | xargs git add 
