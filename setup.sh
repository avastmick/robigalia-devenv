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
# 3. Create alias for running container
# 4. Test
# 5. Drink beer
#
###########################################################

# 1. Install Docker
command -v docker >/dev/null && { echo docker installed;  } || { echo "docker not found, installing."; sudo curl -sSL https://get.docker.com/ | sh; sudo chkconfig docker on; sudo service docker start; echo "You may need to log out to make your user run docker without root. Logout and re-run."; exit;}; 

# 2. Run build docker images
# TODO: check if image exists
echo "Building docker image. This may take some time, depending on your Internet connection..." && \
docker build -t robigalia/devbox .

# 3. Set up remote and init the submodules
git clone --recursive https://gitlab.com/robigalia/devbox.git robigalia && cd robigalia && git submodule update --init --remote
./add_remotes.sh

# 4. Run docker container
# a. Create alias in shell rc
# run
docker run -it --name robigalia --volume "$(pwd)":/src robigalia/devbox
