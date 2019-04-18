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
    g++-multilib \
    libboost-all-dev \
    libc6-dev \
    libdb++-dev \
    libcurl4-openssl-dev && \
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
    zlib1g-dev \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN git clone https://github.com/jl777/komodo --branch dev /komodo
# RUN ./zcutil/fetch-params.sh
ENV HOME /komodo
#    ./zcutil/build.sh -j
