#!/bin/zsh
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

echo "Deleting ${webserver}:${web_dir}"

ssh $web_server "rm -rf $web_dir/*"

echo "Copying ${cp_dir}..."

#Each shell script gets its own sub-shell with a cwd and dir stack
pushd "${cp_dir}/"

git_exclude="./.git"

echo "Excluding ${git_exclude}"


find . \
    -not \( -path $git_exclude -prune \)      \
    -type d  -exec ssh $web_server "cd $web_dir; mkdir {} " \; \
    -o \
    -type f  -exec bash  -c "scp {} $web_server:$web_dir{}" \; 

popd

echo "Chmod 755 ${web_dir}"

ssh $web_server "sudo chmod -R 755 $web_dir"
