FROM alpine:latest as builder
ARG GITHUB_REPO=jl777/komodo.git
ARG GITHUB_BRANCH=dev
RUN set -x && \
    apk add --no-cache --virtual .build-deps \
    autoconf \
    automake \
    boost-dev \
    build-base \
    cargo \
    curl-dev \
    libcurl \
    chrpath \
    curl \
    file \
    git \
    libtool \
    linux-headers \
    m4 \
    musl \
    musl-dev \
    ncurses-dev \
    openssl \
    openssl-dev \
    patch \
    pkgconfig \
    rust \
    tar \
    unzip \
    wget \
    zlib-dev
RUN git clone --depth 1 https://github.com/$GITHUB_REPO --branch $GITHUB_BRANCH /komodo
WORKDIR /komodo
RUN ./autogen.sh && \
    export CFLAGS=" -g " && \
    /bin/bash ./zcutil/build.sh -j$(nproc)

FROM alpine:latest
ARG KUSER=komodo
ARG KHOME=/home/komodo
RUN set -x && \
    apk add --no-cache --virtual .build-deps \
    autoconf \
    automake \
    boost-dev \
    build-base \
    cargo \
    curl-dev \
    libcurl \
    chrpath \
    curl \
    file \
    git \
    libtool \
    linux-headers \
    m4 \
    musl-dev \
    ncurses-dev \
    openssl \
    openssl-dev \
    patch \
    pkgconfig \
    rust \
    tar \
    unzip \
    wget \
    zlib-dev
RUN apk --no-cache add \
    boost \
    boost-program_options \
    libgomp \
    libcurl \
    bash \
    curl \
    wget
RUN addgroup -S ${KUSER} && adduser -D -h ${KHOME} -s /bin/bash -u 1000 ${KUSER} -G ${KUSER}
USER komodo
RUN bash -c 'mkdir -p ${KHOME}/{.komodo,.zcash-params}'
VOLUME ["${KHOME}/.komodo", "${KHOME}/.zcash-params"]
WORKDIR ${KHOME}
RUN mkdir -p ${KHOME}/bin
COPY --from=builder --chown=komodo ["/komodo/src/komodod", "/komodo/src/komodo-cli", "/komodo/zcutil/fetch-params.sh", "${KHOME}/bin/"]
#RUN fetch_params
EXPOSE 7770


#ENTRYPOINT ["komodod"]
