# A Better Robigalia Development Experience

The aim is to collate various tips and tricks to improve the installation and development / contribution to robigalia project.

## TL;DR;

1. Fork https://gitlab.com/robigalia/devbox.git to your own account on gitlab.com
1. run the following:

```$bash
git clone https://gitlab.com/[YOUR_USER]/robigalia-devenv.git
./setup.sh
```

This will:

- Install Docker if it is not already installed
- Build a development docker image similar to the Robigalia CI image
- Clone the gitlab.com/robigalia/devbox project
- Change the upstream remote (assumes you have already forked)
- Run an ephemeral container
- *TODO: auto-run the hello-world build*

## Manual

- Fork the robigalia/devbox project, then:

```bash
git clone git@gitlab.com:[YOUR_USER]/devbox.git robigalia
git remote add upstream git@gitlab.com:robigalia/devbox.git
git submodule update --init --recursive --remote
git remote set-url origin
```

- Run from the root of this repo (*not the robigalia/devbox repo*):

```bash
docker build -t robigalia/devbox .
docker run -it --rm --volume "$(pwd)":/src robigalia/devbox
```

This *should* give you everything you need.

If everything works fine, then

```bash
docker run -it --name robigalia-dev --volume "$(pwd)":/src robigalia/devbox
```

## TODO

- Testing via QEMU - see the CI image
- Create a test script to import into image to auto-execute the hello-world build
