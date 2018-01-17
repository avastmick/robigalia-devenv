# Easy Robigalia Development Setup

The aim is to collate various tips and tricks into scripts to improve the installation and development / contribution to robigalia project. 

This is entirely based on Docker. This is good for those who do not want to add any specific configuration for the Robigalia that may break something else on their machine. This should work on any variety of Linux, including WSL on Windows.

## TL;DR;

1. Fork https://gitlab.com/robigalia/devbox.git to your own account on gitlab.com/YOUR_USERNAME
1. Run the following:

```$bash
git clone https://gitlab.com/[YOUR_USERNAME]/robigalia-devenv.git
cd robigalia-devenv
./setup.sh [YOUR_USERNAME]
```

## ``./setup.sh``

This will:

- Install Docker if it is not already installed
- Build a development docker image similar to the Robigalia CI image
- Clone the gitlab.com/robigalia/devbox project
- Change the upstream remote (assumes you have already forked)
- Run an ephemeral container, and
- Drop you into a bash prompt inside the container

## Testing

To test all is good at the container bash prompt:

```$bash
root@9cf52c86f557:/# cd src
root@9cf52c86f557:/# ./hello-world.sh
root@9cf52c86f557:/# exit
```

- This will put a kernel into `sel4/stage/kernel-x86_64-pc99`
- And the hello-world binaries into `target/x86_64-sel4-robigalia/release/hello-world`

You can run these on a Dockerized QEMU:

```$bash
cd /path/to/your/robigalia-devenv
./qemu-test qemu-system-x86_64 -nographic -kernel ./sel4/stage/kernel-x86_64-pc99  -initrd ./hello-world/target/x86_64-sel4-robigalia/release/hello-world
```

The ``qeu-test`` script pulls down the ``tianon/qemu`` image and wraps it. Pass to it the usual QEMU args to test binaries and kernel

### Manual QEMU via Docker

```$bash
docker pull tianon/qemu
touch $HOME/hda.qcow2
docker run -it --rm \
    --device /dev/kvm \
    --name qemu-container \
    -v $HOME/hda.qcow2:/tmp/hda.qcow2 \
    -v "$(pwd)"/robigalia:/src \
    -e QEMU_HDA=/tmp/hda.qcow2 \
    -e QEMU_HDA_SIZE=100G \
    -e QEMU_CPU=4 \
    -e QEMU_RAM=4096 \
    -e QEMU_BOOT='order=d' \
    -e QEMU_PORTS='2375 2376' \
    tianon/qemu \
    qemu-system-x86_64 -nographic -kernel /src/sel4/stage/kernel-x86_64-pc99 -initrd /src/hello-world/target/x86_64-sel4-robigalia/release/hello-world
```

## Manual Setup

- Fork the robigalia/devbox project, then:

```bash
git clone https://gitlab.com/robigalia/devbox.git
git submodule update --init --recursive --remote
git remote rename origin upstream && git remote add origin git@gitlab.com:[YOUR_USERNAME]/devbox.git && git fetch origin && git branch -u origin/master master
```

- Run from the root of this repo (*not the robigalia/devbox repo*):

```bash
docker build -t robigalia/devbox .
cd robigalia
docker run -it --rm --volume "$(pwd)":/src robigalia/devbox
```

This *should* give you everything you need.

If everything works fine, then

```bash
docker run -it --name robigalia-dev --volume "$(pwd)":/src robigalia/devbox
```

You should be able to now hack away on either the Robigalia subprojects (fork upstream and change the submodule directory remote accordingly), or include your own (my plan)!
