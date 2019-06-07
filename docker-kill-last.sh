#Kills the most recently started docker container.

containerName="$(docker ps -n 1)"

printf "Stopping:\n$containerName\n" 

read -r -p "Are you sure? [Y/n]" input

case $input in
	[yY][eE][sS]|[yY])
docker stop $( docker ps -aqn 1 )
;;
esac

docker ps
