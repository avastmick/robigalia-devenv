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

# 1. Install Docker
command -v docker >/dev/null && { echo docker installed;  } || { echo "docker not found, installing."; sudo curl -sSL https://get.docker.com/ | sh; sudo chkconfig docker on; sudo service docker start; echo "You may need to log out to make your user run docker without root. Logout and re-run."; exit;}; 

# 2. Run build docker images
if [[ "$(docker images -q robigalia/devbox 2> /dev/null)" == "" ]]; then
    echo "Building docker image. This may take some time, depending on your Internet connection..." 
    docker build -t robigalia/devbox .
    echo "Done."
fi

# 3. Set up remote and init the submodules
echo "Cloning Robigalia devbox project..."
git clone --recursive https://gitlab.com/robigalia/devbox.git robigalia && cd robigalia && git submodule update --init --remote 
if [ -z "$1" ]; then
    read -p "What's your gitlab.com username? " username
else
    username=$1
fi
git remote rename origin upstream && git remote add origin git@gitlab.com/$username/$file.git

# 4. Run docker container
# run
docker run --rm -it --name robigalia --volume "$(pwd)":/src robigalia/devbox
