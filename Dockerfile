FROM debian:9-slim AS builder

ARG GITHUB_REPO=jl777/komodo.git
ARG GITHUB_BRANCH=dev
ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_PACKAGES="build-essential ca-certificates pkg-config libcurl3-gnutls-dev libc6-dev libevent-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python zlib1g-dev curl wget bsdmainutils automake libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libqt4-dev libqrencode-dev libdb++-dev"
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install --no-install-recommends ${BUILD_PACKAGES}
RUN git clone https://github.com/$GITHUB_REPO --depth 1 --branch $GITHUB_BRANCH /komodo
WORKDIR /komodo
RUN ./zcutil/build.sh -j$(nproc)

FROM debian:9-slim
ARG KUSER=komodo
ARG KHOME=/home/komodo
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get -y install \
    curl \
    jq \
    libcurl3-gnutls-dev \
    libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN adduser --disabled-password --gecos "" -home ${KHOME} --shell /bin/bash --uid 1000 ${KUSER}
USER ${KUSER}
RUN /bin/bash -c "mkdir -p ${KHOME}/{.komodo,.zcash-params,bin}"
#VOLUME ["${KHOME}/.komodo", "${KHOME}/.zcash-params"]
WORKDIR ${KHOME}
COPY --from=builder --chown=komodo ["/komodo/src/komodod", "/komodo/src/komodo-cli", "/komodo/zcutil/fetch-params.sh", "${KHOME}/bin/"]
COPY --chown=komodo ["entrypoint.sh", "${KHOME}/bin/"]
#ENTRYPOINT ["bin/entrypoint.sh"]
