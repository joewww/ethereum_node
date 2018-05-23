#!/bin/sh

# startup.sh
sleep 7

# check volume is mounted
check_mounted() {
  if [ -d /var/ethereum-data/geth ]
  then
    mounted=0
  else
    mounted=1
  fi
  return "$mounted"
}

# mount volume
mount_ebs() {
  if check_mounted
  then
    echo "EBS already mounted"
    ret=0
  else
    echo "Mounting EBS.."
    sudo mount /dev/xvdf /var/ethereum-data/
    ret="$?"
  fi
 return "$ret"
}

# enable rpc
if mount_ebs
then
  sudo su - ubuntu -c "nohup geth --syncmode "fast" --datadir "/var/ethereum-data" --cache 1024 --rpc --rpcport "8545" --rpcaddr "0.0.0.0" --rpccorsdomain \* --rpcvhosts \* &"
else
  echo "Volume is NOT mounted"
fi

# EOF
