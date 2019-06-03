#!/bin/bash
# This command can be used to copy files into a docker volume.
# The steps it follows are:
#   1 ) Run a temporary docker volume using the alpine image ( --rm flag )
#   2 ) Mount the local directory ( $1 ) as /source in the container
#   3 ) Mount the destination volume ( $2 ) as /dest in the container
#   4 ) Use /bin/ash to copy the files across

display_usage ()
{
    printf "\n"
    printf "docker-vol-cp [local_dir] [local_files] [dest_volume] [dest_dir]"
    printf "\n"
    printf "Creates a tempory docker container from the Alpine image and \n"
    printf "uses it to copy files from the host machine into a docker \n"
    printf "volume.\n"
    printf "\n\n"
    printf "Parameters:\n"
    printf "1) local_dir - The directory specified will be mounted as the \n"
    printf "               /source/ directory in the transfer machine.\n\n"
    printf "2) local_files - Glob pattern used to reference the files \n"
    printf "                 from the source directory.\n"
    printf "                 Note: wildcards should be escaped\n\n"
    printf "3) dest_volume - Docker volume name to transfer files.\n\n"
    printf "4) dest_dir - Directory to mount as /dest/ in the transfer \n"
    printf "              container.\n\n"
    printf "Example usage:\n"
    printf "    sudo docker-vol-cp.sh . \*.png repeat-images .\n"
    printf "Copies all png files in current dir to root of repeat-images \n"
    printf "volume,\n"
    printf "\n"
}

if [ $# -lt 3 ]
then
    display_usage
    exit 1
fi

local_dir=$(readlink -m -n $1)
local_files=$2

target_volume=$3

target_dir="/dest/$4"

printf "\n--> $target_dir\n"

printf "\nCopying $local_files from $local_dir to $target_volume\n"

docker run --rm -v $local_dir:/source                                       \
                -v $target_volume:/dest                                     \
                -w /source                                                  \
                alpine                                                      \
                /bin/ash -c "mkdir -p $target_dir &&                        \
                             cp -rf $local_files $target_dir"
