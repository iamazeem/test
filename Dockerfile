FROM rubylang/ruby:2.6.3-bionic

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y \
        ca-certificates \
        lsb-release \
        wget && \
    wget -q https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt-get install -y ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb && \
    apt-get update && \
    apt-get install -y \
        libarrow-dev \
        libarrow-glib-dev \
        libparquet-dev \
        libparquet-glib-dev && \
    rm apache-arrow-apt-source-latest-*.deb

RUN \
    apt-get update && \
    apt-get install -y \
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
        pkg-config

RUN \
    export VERSION="0.15.0" && \
    export DIR_NAME="thrift-$VERSION" && \
    export ARCHIVE_NAME="$DIR_NAME.tar.gz" && \
    wget -q "http://archive.apache.org/dist/thrift/$VERSION/$ARCHIVE_NAME" && \
    tar -xzf "$ARCHIVE_NAME" && \
    rm "$ARCHIVE_NAME" && \
    cd "$DIR_NAME" && \
    ./bootstrap.sh && \
    ./configure \
        --disable-debug \
        --disable-tests \
        --disable-tutorial \
        --disable-dependency-tracking \
        --without-python \
        --without-py3 \
        --without-go && \
    make && \
    make install

CMD [ "/bin/bash" ]
