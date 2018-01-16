# A Better Robigalia Development Experience

The aim is to collate various tips and tricks to improve the installation and development / contribution to robigalia project.

## Repository

- Fork the robigalia/devbox project
- ``$ git clone git@gitlab.com:[YOUR_USER]/devbox.git robigalia``
- ``$ git remote add upstream git@gitlab.com:robigalia/devbox.git``
- ``$ git submodule update --init --recursive --remote``

TODO: Create a script that initialises the repo from the submodules and builds the docker image locally

run from the root of the repo:

``docker run -it --rm --volume "$(pwd)":/src robigalia/devbox``

*Should* give you everything you need.

## Rust settings

### Toolchain

Rather than setting a system-wide toolchain, set at a project level:

``$ rustup override set nightly-2017-12-13``

### PATH settings

TODO:

In the project there is a ``$PATH`` setting:

``export RUST_TARGET_PATH=$HOME/proj/robigalia/sel4-targets``, this is supposed to be added to your shell rc file, in my case the ``.zshrc``, but it clashes then with any other Rust project (see above with regard to Toolchain settting.)

## Docker

Docker would solve many of the above issues and isolate the host machine configuration from the (complexity) of building the Robigalia workbench.

## TODO

- Build new Docker image that is more friendly for local development
- Create a script to set it all up, rather than user keyed steps
- Get on their message / forum to contribute
- Work out how to fork the repos simply to ensure that contrib PRs can be done smoothly
- Testing via QEMU - see the CI image
