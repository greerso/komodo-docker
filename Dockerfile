FROM ubuntu:18.04 AS builder

ARG GITHUB_REPO=jl777/komodo.git
ARG GITHUB_BRANCH=dev
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y dist-upgrade
RUN apt-get -y install \
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
    ./configure --with-incompatible-bdb || true && \
    ./zcutil/build.sh -j$(nproc)

FROM ubuntu:18.04
ARG KUSER=komodo
ARG KHOME=/home/komodo
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install \
    libcurl4 \
    libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN adduser --disabled-password --gecos "" -home ${KHOME} --shell /bin/bash --uid 1000 ${KUSER}
#USER ${KUSER}
RUN /bin/bash -c "mkdir -p ${KHOME}/{.komodo,.zcash-params}"
VOLUME ["${KHOME}/.komodo", "${KHOME}/.zcash-params"]
WORKDIR ${KHOME}
RUN mkdir -p ${KHOME}/bin
COPY --from=builder --chown=komodo ["/komodo/src/komodod", "/komodo/src/komodo-cli", "/komodo/zcutil/fetch-params.sh", "${KHOME}/bin/"]
#RUN fetch_params
#EXPOSE 7770


#ENTRYPOINT ["komodod"]
