
# ♢ ethereum_node

## Overview

![aws layout](/gfx/aws-eth.png)

## Monthly Costs
  - t2.medium: ~$33.41
  - 120G EBS: ~$12.00
  - Total     = $45.41

## AMI
  - using t2.medium (1x)
  - install geth: bin/install.sh
  - add bin/startup.sh to /etc/rc.local
  - `mkdir /var/ethereum-data/ && chown ubuntu: /var/ethereum-data/`


## mount EBS volume, start client

`$ sh bin/startup.sh`


### start geth manually, enable RPC

`$ geth --syncmode "fast" --datadir "/var/ethereum-data" --cache 1024 --rpc --rpcport "8545" --rpcaddr "0.0.0.0" --rpccorsdomain "*"`


### no RPC

`$ geth --rinkeby --syncmode "fast" --datadir "/var/ethereum-data" --cache 1024`


## migrate database to fresh directory
https://github.com/ethereum/go-ethereum/issues/15797#issuecomment-357030043

`mkdir /var/new-ethereum-data`

`geth --datadir=/var/new-ethereum-data copydb --cache=512 /var/ethereum-data`

`rm -rf /var/ethereum-data`

`mv /var/new-ethereum-data /var/ethereum-data`


## env variables used by runner
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_DEFAULT_REGION    = us-east-1`
