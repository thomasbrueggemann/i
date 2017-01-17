FROM ubuntu:16.04
MAINTAINER Thomas Brüggemann <mail@thomasbrueggemann.com>
LABEL Description="Digital multi-dimensional data representation of myself" Vendor="Thomas Brüggemann" Version="1.0.0"
EXPOSE 18080

# DEPENDENCIES
RUN apt-get update -y && apt-get install -y  software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update -y && apt-get install -y libboost-all-dev g++-5 build-essential wget git pkg-config

# libmongoc
RUN apt-get install -y pkg-config libssl-dev libsasl2-dev wget
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.5.1/mongo-c-driver-1.5.1.tar.gz
RUN tar xzf mongo-c-driver-1.5.1.tar.gz
WORKDIR mongo-c-driver-1.5.1
RUN ./configure --disable-automatic-init-and-cleanup
RUN make
RUN make install
WORKDIR /

RUN add-apt-repository ppa:george-edison55/cmake-3.x
RUN apt-get update -y
RUN apt-get install -y cmake

# mongocxx
RUN git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/stable --depth 1
WORKDIR mongo-cxx-driver/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. -DBSONCXX_POLY_USE_MNMLSTC=1
RUN make EP_mnmlstc_core
RUN make install

# BUILD
COPY ./ /home
WORKDIR /home
RUN make

# ENTRYPOINT
ENTRYPOINT exec bin/ich
