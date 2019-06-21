# Command to send a source file to the web-assembly build server,
# compile it and copy the results back

#Username@Hostname for the server used to build webassembly
build_server="boop@web-asm"

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
