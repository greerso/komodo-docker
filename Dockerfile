FROM debian:buster-slim AS builder

ARG GITHUB_URL=https://github.com/jl777/komodo.git
ARG GITHUB_BRANCH=dev

RUN apt -y update && \
    apt -y dist-upgrade && \
    apt -y install apt-utils && \
    apt -y install \
    autoconf \
    automake \
    bsdmainutils \
    build-essential \
    clang \
    cmake \
    curl \
    g++-multilib \
    git \
    libdb++-dev \
    libboost-all-dev \
    libc6-dev \
    libgtest-dev \
    libcurl4-openssl-dev \
    libdb++-dev \
    libprotobuf-dev \
    libqrencode-dev \
    libqt4-dev \
    libtool \
    libssl-dev \
    m4 \
    ncurses-dev \
    ntp \
    ntpdate \
    pkg-config \
    protobuf-compiler \
    python \
    software-properties-common \
    unzip \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN git clone https://github.com/jl777/komodo --branch dev && \
    cd komodo
RUN ./zcutil/fetch-params.sh
RUN ./zcutil/build.sh -j
