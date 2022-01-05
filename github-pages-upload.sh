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

GHP_BRANCH="gh-pages"
PROJECT_DIR=$PWD
BUILD_DIR=$(readlink -m $1)
WORK_TREE_DIR=$(readlink -m ./$GHP_BRANCH)

printf "Project dir: $PROJECT_DIR\n";
printf "Build dir: $BUILD_DIR\n";
printf "Work tree dir: $WORK_TREE_DIR\n";

if [ ! -f ".gitignore" ]
then
   printf "Creating gitignore\n"
   touch ".gitignore"
fi

if ! grep -q "^/${GHP_BRANCH}/" ".gitignore"
then
   printf "Add $GHP_BRANCH to .gitignore\n"
   echo "/$GHP_BRANCH/" >> ".gitignore"
fi

if [ ! -d $BUILD_DIR ]
then
   printf "Could not find build dir at: $BUILD_DIR\n"
   exit 1
fi

if [ -d $WORK_TREE_DIR ]
then
   printf "Work tree dir already exists.\n"
   exit 1
fi

printf "Creating worktree.\n"

git worktree add -B $GHP_BRANCH $WORK_TREE_DIR

printf "Copying $BUILD_DIR to github pages.\n"

cd $WORK_TREE_DIR
git branch --set-upstream-to=origin/$GHP_BRANCH $GHP_BRANCH
git fetch --all
git reset --hard origin/$GHP_BRANCH

printf "Pushing build files to github\n"

rsync -vr $BUILD_DIR/ $WORK_TREE_DIR --delete --exclude='.git*'
git add .
git commit -m "Copy build files to gh-pages."
git push

printf "Removing gh-pages tree.\n"
cd $PROJECT_DIR
git worktree remove $GHP_BRANCH
