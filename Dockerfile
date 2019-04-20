FROM ubuntu:18.04

ARG GITHUB_REPO=jl777/komodo.git
ARG GITHUB_BRANCH=dev

RUN apt-get -y update && \
    apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    autoconf \
    automake \
    bsdmainutils \
    build-essential \
    curl \
    g++-multilib \
    git \
    libc6-dev \
    libdb++-dev \
    libcurl4-openssl-dev \
    libprotobuf-dev \
    libqrencode-dev \
    libssl-dev \
    libtool \
    m4 \
    ncurses-dev \
    protobuf-compiler \
    pkg-config \
    python \
    software-properties-common \
    unzip \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN git clone https://github.com/$GITHUB_REPO --branch $GITHUB_BRANCH /komodo
# RUN ./zcutil/fetch-params.sh
ENV HOME /komodo
RUN ./autogen.sh && \
    ./configure --with-incompatible-bdb --with-gui || true && \
    ./zcutil/build.sh -j$(nproc)
