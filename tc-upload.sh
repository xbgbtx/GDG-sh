#!/bin/bash
# Command to upload a directory to webserver and exlcude git files

web_server="tc@tc"
web_dir="/usr/local/apache2/htdocs/"

display_usage ()
{
    printf "\n"
    printf "add-path [dir]"
    printf "\n"
}

if [ $# -lt 1 ]
then
    display_usage
    exit 1
fi

cp_dir=$(readlink -m $1)

if [ ! -d $cp_dir ]
then
    printf "\nNot a valid directory:  $cp_dir\n"
    exit 1
fi

echo "Copying ${cp_dir}..."

git_exclude="*.git"

echo "Excluding ${git_exclude}"

ssh $web_server "rm -rf $web_dir/*"

find $cp_dir -not \( -path $git_exclude -prune \) -print0      \
    | xargs -0 -I{} echo {} `realpath -m --relative-to=$cp_dir {}`

