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

#Regex used to search path for the new_dir.  Directories on the $PATH
#are separated by colons ( : ) so the directory will have a colon on either
#side or be at the start or end of the string

path_regex="(^|:)$new_dir($|:)"

if [[ $PATH =~ $path_regex ]]
then
    printf "\nDirectory is already in PATH:  $new_dir\n"
    exit 1
fi

echo -e "if [ -d \"$new_dir\" ]; then" >> ~/.profile
echo -e "   PATH=$new_dir:\$PATH" >> ~/.profile
echo -e "fi\n" >> ~/.profile
