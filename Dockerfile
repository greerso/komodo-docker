FROM ubuntu:18.04 AS builder

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
WORKDIR /komodo
RUN ./autogen.sh && \
    ./configure --with-incompatible-bdb --with-gui || true && \
    ./zcutil/build.sh -j$(nproc)

FROM alpine:latest

RUN adduser -D -u 1000 komodo
USER komodo
VOLUME ["/home/komodo/.komodo"]
VOLUME ["/home/komodo/.zcash-params"]
WORKDIR /home/komodo
COPY --from=builder --chown=komodo ["/komodo/komodod", "/komodo/komodo-cli", "/komodo/zcutil/fetch_params.sh", "/usr/local/bin/"]
RUN fetch_params
EXPOSE 7770


ENTRYPOINT ["komodod"]
