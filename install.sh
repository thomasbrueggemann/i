#!/bin/bash

sudo apt-get update -y && apt-get install -y  software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update -y && apt-get install -y libboost-all-dev g++-5 build-essential wget git pkg-config

# libmongoc
sudo apt-get install -y pkg-config libssl-dev libsasl2-dev wget
sudo wget https://github.com/mongodb/mongo-c-driver/releases/download/1.5.1/mongo-c-driver-1.5.1.tar.gz
sudo tar xzf mongo-c-driver-1.5.1.tar.gz
cd mongo-c-driver-1.5.1
sudo ./configure --disable-automatic-init-and-cleanup
sudo make
sudo make install
cd ..

sudo add-apt-repository ppa:george-edison55/cmake-3.x
sudo apt-get update -y
sudo apt-get install -y cmake

# mongocxx
sudo git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/stable --depth 1
cd mongo-cxx-driver/build
sudo cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. -DBSONCXX_POLY_USE_MNMLSTC=1
sudo make EP_mnmlstc_core
sudo make install

# BUILD
sudo make
