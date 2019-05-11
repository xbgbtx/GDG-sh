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

if [ ! -d $1 ]
then
    printf "\nNot a valid directory:  $1\n"
    exit 1
fi
