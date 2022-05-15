FROM ruby:2.6.3

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
    wget -q http://ftp.debian.org/debian/pool/main/a/automake-1.15/automake_1.15-3_all.deb && \
    apt-get install -y ./automake_1.15-3_all.deb

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
