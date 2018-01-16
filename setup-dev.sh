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
echo "Building docker image. This may take some time, depending on your Internet connection..." && cp ../runner/toolchain-nightly-date . && \
docker build -t robigalia/devbox .

# 3. Set up remote and init the submodules
cd .. && git remote add upstream git@gitlab.com:robigalia/devbox.git && \
git submodule update --init --recursive --remote

# 4. Run docker
# a. Create alias in shell rc
# run
cd .. && \
docker run -it --rm --volume "$(pwd)":/src robigalia/devbox

# 5. Drink beer
echo Mmmmm, beer!
