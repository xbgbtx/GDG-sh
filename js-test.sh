# Command to send a source file to the web-assembly build server,
# and run jest test

#Username@Hostname for the server used to build webassembly
build_server="boop@web-asm"

#directory to perform the build on the build server
build_path="/tmp/jest-test"

#directory with the testing environment files
test_env_files="/home/boop/JestTestEnvironment"

#command + otions to perform the tests
build_cmd="npm run test"

display_usage ()
{
	printf "\n"
	printf "js-test.sh [source_file]\n"
	printf "\n"
	printf "Sends the sourcefile to the web-asm build server and\n"
	printf "uses jest to perform unit testing.\n"
	printf "\n"
}

if [ $# -lt 1 ]
then
	display_usage
	exit 1
fi

#Full path and filename of the source file
source_path=$(readlink -m -n $1)
source_file=$(basename $source_path)

#create build dir 
ssh $build_server "mkdir -p $build_path"

#Copy test environment files
ssh $build_server "cp -r $test_env_files/* $build_path"

#copy source file to the build dir on the build server
scp $source_path $build_server:$build_path

#execute the build command
ssh $build_server "cd $build_path && $build_cmd $source_file"

#remove the build folder on build server
ssh $build_server "rm -rf $build_path"
