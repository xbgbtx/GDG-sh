#!/bin/bash

# This command can be used to display all of the files in a docker container.
# It works by starting a temporary container ( --rm ) using the alpine 
# image.  It then uses /bin/ash to run the 'ls' command with some options to
# make the listing recursive and somewhat readable.

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

#docker volume ls is used with a filter to list only the volumes whose name
#completely matches the first parameter

filter="name=^"+$1+"$"

volume=$(docker volume ls -qf $filter )

if [[ $volume != $1 ]]
then
    printf "\nVolume $1 does not exist.\n"
    printf "\nValid volume names:\n"

    docker volume ls

    exit 1
fi

docker run --rm            \
           -v $volume:/vol/ \
           alpine          \
           /bin/ash -c "ls -RAhl /vol/"
