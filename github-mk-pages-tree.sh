#!/bin/bash
# Creates a worktree called gh-pages for hosting site

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
if [ "$?" -ne 0 ]
then
   printf "Command should be called inside a repo\n"
   exit 1
fi

if [ ! -d "./.git/" ]
then
   printf "Command should be called in the root dir of a repo\n"
   exit 1
fi

GHP_DIR="gh-pages"

if [ ! -f ".gitignore" ]
then
   printf "Creating gitignore\n"
   touch ".gitignore"
fi

if ! grep -q "^/${GHP_DIR}/" ".gitignore"
then
   printf "Add $GHP_DIR to .gitignore\n"
   echo "/$GHP_DIR/" >> ".gitignore"
fi

printf "Creating worktree.\n"

git worktree add -B $GHP_DIR $GHP_DIR
