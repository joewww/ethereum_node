#!/bin/sh

# Install go-ethereum client

sudo apt-get update 
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install -y ethereum


