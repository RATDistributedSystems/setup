#!/bin/bash

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd "$@" > /dev/null
}

# Update all the relavent code
git submodule update --init
git submodule -q foreach git pull -q origin master
pushd ~/go/src/github.com/RATDistributedSystems/utilities
git pull
popd

# Build all the dockerfiles
DOCK_DIR=$(find . -name "Dockerfile" -exec dirname {} \; | xargs echo -n)
NUM=0
for d in $DOCK_DIR; do
    pushd $d
    NAME=$(basename $d)
    CGO_ENABLED=0 GOOS=linux go build -a --installsuffix cgo --ldflags="-s" -o  $NAME
    ./setup_image.sh
    NUM=$((NUM + 1))
    popd
done

# Clean the useless crap
git submodule update --init

# Save all the docker files in ~/Documents
mkdir -p $HOME/Documents/docker-images
cp ../variables.env ../docker-compose.yml ../seeds-compose.yml ../cluster-compose.yml load.sh deploy.sh ~/Documents/docker-images
echo -e "\nFiles will be stored in $HOME/Documents/docker-images"

DOCK_IMGS=$(docker images | head -$((NUM + 1)) | tail -$NUM | awk '{print $1}' | xargs echo -n)
ext=".docker"
# Download them
for img in $DOCK_IMGS; do
    docker save -o $HOME/Documents/docker-images/$img$ext $img
    echo "saving $img as $img$ext"
done

# Other images
docker save -o $HOME/Documents/docker-images/redis.docker redis
docker save -o $HOME/Documents/docker-images/cassandra.docker cassandra
