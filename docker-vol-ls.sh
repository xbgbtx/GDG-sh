#!/bin/bash

# This command can be used to display all of the files in a docker container.
# It works by starting a temporary container ( --rm ) using the alpine 
# image.  It then uses /bin/ash to run the 'ls' command with some options to
# make the listing recursive and somewhat readable.

#TODO
# BUG - If a volume doesn't exist then it is created this this command.
#     - In order to check that a volume exists use the command:
#                    docker volume ls -q -f 'name=$name'
#     - Note that this command returns a list of all volumes matching
#     - a regex of the name.  May be able to use 'anchors' to avoid this


display_usage ()
{
    printf "\n"
    printf "docker-vol-ls [volume_name]\n"
    printf " - Displays a list of all files in a docker volume."
    printf "\n"
}

if [ $# -lt 1 ]
then
    display_usage
    exit 1
fi

volume=$1

docker run --rm            \
           -v $volume:/vol/ \
           alpine          \
           /bin/ash -c "ls -RAhl /vol/"
