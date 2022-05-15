FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends --fix-missing \
        automake \
        bison \
        flex \
        g++ \
        git \
        libboost-all-dev \
        libevent-dev \
        libssl-dev \
        libtool \
        make \
        pkg-config \
        wget \
        tar \
        ruby-dev \
        python-dev

RUN \
    export VERSION="0.15.0" && \
    export DIR_NAME="thrift-$VERSION" && \
    export ARCHIVE_NAME="$DIR_NAME.tar.gz" && \
    wget -q "http://archive.apache.org/dist/thrift/$VERSION/$ARCHIVE_NAME" && \
    tar -xzf "$ARCHIVE_NAME" && \
    rm "$ARCHIVE_NAME" && \
    cd "$DIR_NAME" && \
    ./bootstrap.sh && \
    ./configure --help && \
    ./configure && \
    make && \
    make install

CMD [ "/bin/bash" ]
