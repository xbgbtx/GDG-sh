#!/bin/bash
# Copy the contents of dir in args to gh-pages and
# Upload the contents of gh-pages/ to github repo

display_usage ()
{
    printf "github-pages-upload.sh [build-dir]"
    printf "\n"
}

if [ ! $# -eq 1 ]
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
BUILD_DIR=$(readlink -m $1)

if [ ! -d $BUILD_DIR ]
then
   printf "Could not find build dir at: $BUILD_DIR\n"
   exit 1
fi

if [ -d $GHP_DIR ]
then
   printf "gh-pages dir already exists.\n"
   exit 1
fi

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

printf "Copying $BUILD_DIR to github pages.\n"

cp -r $BUILD_DIR/* $GHP_DIR


cd $GHP_DIR
git branch --set-upstream-to=origin/$GHP_DIR $GHP_DIR
git fetch --all
git reset --hard origin/$GHP_DIR

printf "Pushing build files to github"

rsync -vr $BUILD_DIR . --delete
git add -A
git commit -m "Copy build files to gh-pages."
git push

printf "Removing gh-pages tree.\n"
cd ..
git worktree remove $GHP_DIR
