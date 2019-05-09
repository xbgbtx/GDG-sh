# This command can be used to copy files into a docker volume.
# The steps it follows are:
#   1 ) Run a temporary docker volume using the alpine image ( --rm flag )
#   2 ) Mount the current working directory as /source in the container
#   3 ) Mount the destination volume ( $2 ) as /dest in the container
#   4 ) 
# note: may not work correctly atm because the cp does not specify the dir

local_dir=$(readlink -m -n $1)
local_files=$2

target_volume=$3

printf "\nCopying $local_files from $local_dir to $target_volume\n"

docker run --rm -v $local_dir:/source                      \
                -v $target_volume:/dest                    \
                -w /source                                 \
                alpine                                     \
                /bin/ash -c "cp -r $local_files /dest"
