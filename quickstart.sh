#!/bin/bash

set -e

case "$1" in
standalone)
    echo "Using standalone network"
    ARGS="--standalone"
    ;;
futurenet)
    echo "Using Futurenet network"
    ARGS="--futurenet"
    ;;
*)
    echo "Usage: $0 standalone|futurenet"
    exit 1
    ;;
esac

# Run the soroban-preview container
# Remember to do 
# cd docker
# bash build.sh

echo "Searching for a previous soroban-preview-10 docker container"
containerID=$(docker ps --filter="name=soroban-preview" --all --quiet)
if [[ ${containerID} ]]; then
    echo "Start removing soroban-preview-10  container."
    docker rm --force soroban-preview-10
    echo "Finished removing soroban-preview-10 container."
else
    echo "No previous soroban-preview-10 container was found"
fi

currentDir=$(pwd)
docker run --volume  ${currentDir}:/workspace \
           --name soroban-preview-10 \
           --interactive \
           --tty \
           -p 8001:8000 \
           --detach \
           --ipc=host \
           --network soroban-network \
           esteblock/soroban-preview:10

# Run the stellar quickstart image
docker run --rm -ti \
  --platform linux/amd64 \
  --name stellar \
  --network soroban-network \
  -p 8000:8000 \
  stellar/quickstart:soroban-dev@sha256:8a99332f834ca82e3ac1418143736af59b5288e792d1c4278d6c547c6ed8da3b \
  $ARGS \
  --enable-soroban-rpc \
  --protocol-version 20 
