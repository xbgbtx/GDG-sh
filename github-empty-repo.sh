#!/bin/bash
# Sends the current working directory to an empty github repo.
# Repo must exist with the same name as this directory

display_usage ()
{
    printf "Use from inside folder to upload:\n"
    printf "github-empty-repo"
    printf "\n"
}

if [ ! $# -eq 0 ]
then
    display_usage
    exit 1
fi

# Silent check if current dir is in a repo
git rev-parse --is-inside-work-tree &> /dev/null
if [ "$?" -ne 128 ]
then
   printf "This is already a git repo\n"
   exit 1
fi

DIR=$(basename $PWD)
REPO_URL="git@xbgbtx.github.com:xbgbtx/$DIR.git"
README="./README.md"

if [ ! -f "$README" ] ; then
   printf "No readme file found.  Creating one.\n"
   echo "Todo: make a readme" >> "$README" 
fi

printf "Attempting upload to $REPO_URL\n"

git init
git add $README
git commit -m "First commit"
git branch -M main
git remote add origin $REPO_URL
git push -u origin main
