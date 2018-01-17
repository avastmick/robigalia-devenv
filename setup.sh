#!/bin/bash

###########################################################
#
# Sets up a complete Robigalia development environment
# - Pre-requisites:
# 1. Installed Git
#
# - This script runs the following:
# 1. Install Docker
# 2. Build docker image
# 3. TODO: Test
# 4. Drink beer
#
###########################################################
ROBIGALIA_DIR="robigalia"
ROBIGALIA_CONTAINER="robigalia-dev"
# 1. Install Docker
command -v docker >/dev/null && { echo "Docker installed";  } || { echo "docker not found, installing."; sudo curl -sSL https://get.docker.com/ | sh; sudo chkconfig docker on; sudo service docker start; echo "You may need to log out to make your user run docker without root. Logout and re-run."; exit;}; 

# 2. Run build docker images
if [ "$(docker images -q robigalia/devbox 2> /dev/null)" == "" ]; then
    echo "Building docker image. This may take some time, depending on your Internet connection..." 
    docker build -t robigalia/devbox .
    echo "Done."
else
    echo "The robigalia/devbox Docker image already exists. Skipping. If you want to rebuild remove the image and rerun this script."
fi
# 3. Set up remote and init the submodules
if [ ! -d "$ROBIGALIA_DIR" ]; then
    echo "Cloning Robigalia devbox project..."
    git clone --recursive https://gitlab.com/robigalia/devbox.git $ROBIGALIA_DIR && cd $ROBIGALIA_DIR && git submodule update --init --remote 
    echo "Setting remote..."
    if [ -z "$1" ]; then
        read -p "What's your gitlab.com username? " username
    else
        username=$1
    fi
    git remote rename origin upstream && git remote add origin git@gitlab.com/$username/$file.git

    cp ../hello-world.sh .
else
    cd $ROBIGALIA_DIR
    echo "The robigalia/devbox repo already exists. Skipping."
fi

# 4. Run docker container
if [ ! "$(docker ps -qa -f name=$ROBIGALIA_CONTAINER)" ]; then
    echo "Running container as $ROBIGALIA_CONTAINER"
    exec docker run -it --name $ROBIGALIA_CONTAINER --volume "$(pwd)":/src robigalia/devbox
else
    echo "$ROBIGALIA_CONTAINER container already exists. Docker rm $ROBIGALIA_CONTAINER, if you want to re run."
    docker start $ROBIGALIA_CONTAINER && docker exec -it $ROBIGALIA_CONTAINER bash
fi
