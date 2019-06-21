# Command to send a source file to the web-assembly build server,
# compile it and copy the results back

#Username@Hostname for the server used to build webassembly
build_server="boop@web-asm"

build_path="/tmp/wasm-build"

emcc="/home/boop/emsdk/fastcomp/emscripten/emcc"

build_cmd="$emcc -O3 -s WASM=1 -s EXTRA_EXPORTED_RUNTIME_METHODS='[\"cwra\"]'"

display_usage ()
{
	printf "\n"
	printf "webasm-build.sh [source_file]\n"
	printf "\n"
	printf "Sends the sourcefile to the web-asm build server, compiles it\n"
	printf "and copies the a.out files back to the current directory.\n"
	printf "\n"
}

if [ $# -lt 1 ]
then
	display_usage
	exit 1
fi

source_path=$(readlink -m -n $1)
source_file=$(basename $source_path)

ssh $build_server "mkdir -p $build_path"

scp $source_path $build_server:$build_path

ssh $build_server "cd $build_path && $build_cmd $source_file"

scp $build_server:$build_path/a.out.* .

ssh $build_server "rm -rf $build_path"
