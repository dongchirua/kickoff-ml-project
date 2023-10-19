#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)

docker rm -f diffusors-${branch}
docker build --build-arg NEW_MAMBA_USER_ID=$(id -u) --build-arg NEW_MAMBA_USER_GID=$(id -g)  -t diffusors:${branch} .
docker run --gpus all \
    --env-file .env \
    -it -d -v $PWD:/workspace \
    -v /data:/data \
    -p 8888:8888 \
    --shm-size=200g --ulimit memlock=-1 --ulimit stack=64000000 \
    --name diffusors-${branch} \
    diffusors:${branch} bash

# Wait for the Docker container to start
sleep 5

# Get the logs from the running Docker container
logs=$(docker logs diffusors-${branch})

# Extract the token from the logs
token=$(echo "${logs}" | grep -oP '(?<=token=)[a-z0-9]*' | head -n 1)

echo "Jupyter Notebook Token: ${token}"
