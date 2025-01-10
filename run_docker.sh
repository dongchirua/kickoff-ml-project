#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)
repo_name=$(basename "$PWD")
image_name=${repo_name}
container_name=${repo_name}-${branch}

docker rm -f ${container_name}
docker build --build-arg MAMBA_USER_ID=$(id -u) --build-arg MAMBA_USER_GID=$(id -g) --build-arg SSH_KEY="$(cat ~/.ssh/id_rsa)"  -t ${image_name} .
docker run --gpus all \
    --env-file .env \
    -it -d -v $PWD:/workspace \
    -v /data:/data \
    -p 8890:8888 \
    --shm-size=200g --ulimit memlock=-1 --ulimit stack=67108864 \
    --name ${container_name} \
    ${image_name}

# Wait for the Docker container to start
sleep 7

# Get the logs from the running Docker container
logs=$(docker logs ${container_name})

# Extract the token from the logs
token=$(echo "${logs}" | grep -oP '(?<=token=)[a-z0-9]*' | head -n 1)

echo "Jupyter Notebook Token: ${token}"
