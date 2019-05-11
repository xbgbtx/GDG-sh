#!/bin/bash
# This command adds a directory to your path by echoing a few lines to:
#   ~/.profile
#
# The command checks if the directory exists before adding it.
#
# The command also checks that the directory isn't already on the path.


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

new_dir=$(readlink -m $1)

if [ ! -d $new_dir ]
then
    printf "\nNot a valid directory:  $new_dir\n"
    exit 1
fi

#TODO:  This currently returns true for incomplete matches.
#       e.g. ~ matches any child path of the home directory
#            paths are separated by : or the end of string ($)
if [[ $PATH == *"$new_dir"* ]]
then
    printf "\nDirectory is already in PATH:  $new_dir\n"
    exit 1
fi

