
volume=$1

docker run --rm            \
           -v $volume:/vol/ \
           alpine          \
           /bin/ash -c "ls -RAhl /vol/"
