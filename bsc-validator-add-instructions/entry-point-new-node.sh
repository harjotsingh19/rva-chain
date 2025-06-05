#!/bin/bash

workspace="/root"
DATA_DIR="/root/rva-node"

NODE_ID="rva-node"


cat ${workspace}/${NODE_ID}/address

validatorAddr=$(cat ${workspace}/${NODE_ID}/address)

echo "validator addres $validatorAddr"


ls $DATA_DIR


echo 

VERBOSE=3


set -x


  cat "file is $DATA_DIR/blspassword.txt"    



   $HOME/geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --syncmode snap --password /dev/null --blspassword ${DATA_DIR}/blspassword.txt --networkid 2200 \
      --http \
      --http.addr 0.0.0.0 \
      --http.port ${HTTP_PORT} \
      --nousb \
      --port ${NETWORK_PORT} \
      --http.corsdomain '*' \
      --http.api web3,eth,debug,admin,personal,miner,net \
      --ipcpath "${DATA_DIR}/geth.ipc" \
      --verbosity 3 \
      --light.serve 50 --pprof.addr 127.0.0.1\
      --pprof \
      --monitor.doublesign \
      --mine \
      -unlock ${validatorAddr} --miner.etherbase ${validatorAddr} \
      --vote --nodiscover --allow-insecure-unlock 
     


set +x
