FROM debian:jessie

LABEL maintainer="avastmick@outlook.com"

ENV DEBIAN_FRONTEND=noninteractive PATH=/root/.cargo/bin:$PATH RUST_TARGET_PATH=/src/sel4-targets

# Set the date of the Nightly to that of the CI build
# TODO: This should ideally be set as a overall project param
ENV NIGHTLY_DATE=2017-12-13

# Base image to enable the sel4 builds
RUN dpkg --add-architecture i386 && \
    dpkg --add-architecture armhf && \
    dpkg --add-architecture armel && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get install -y apt-utils curl --no-install-recommends && \
    echo 'deb http://emdebian.org/tools/debian/ jessie main' >> /etc/apt/sources.list.d/crosstools.list && \
    curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add - && \
    apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \ 
            python python-pip libxml2 \
            build-essential git clang crossbuild-essential-armhf \
            crossbuild-essential-armel llvm libc6-dev:i386 \
            git cmake cmake-data pkg-config libelf-dev libdw-dev elfutils \
            libcurl4-openssl-dev binutils-dev libz-dev libiberty-dev jq \
            libxml2-utils libxml2-dev libxslt-dev python-dev --no-install-recommends && \
    pip install --quiet sel4-deps && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/* && \
    git clone https://github.com/SimonKagstrom/kcov.git && \
    cd kcov && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install && \
    cd ../../ && \
    rm -rf kcov && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly-${NIGHTLY_DATE} && \
    rustup component add rust-src && \
    cargo install xargo


