#!/bin/bash

workspace="/root"
DATA_DIR="/root/bsc-node"
# HTTP_PORT=8545
# NETWORK_PORT=30305
NODE_ID="bsc-node"

echo "cat"
cat ${workspace}/${NODE_ID}/address

validatorAddr=$(cat ${workspace}/${NODE_ID}/address)

echo "validator addres $validatorAddr"

echo "ls"
ls $DATA_DIR


echo 


# BOOTSTRAP_PUB_KEY=177ae5db445a2f70db781b019aedd928f5b1528a7a43448840b022408f9a21509adcce0b37c87d59da68d47a16879cc1e95a62bbac9723f7b22f4365b2afabbe
# BOOTSTRAP_TCP_PORT=30311
VERBOSE=3
# BOOTSTRAP_HOST=127.0.0.1


# BOOTSTRAP_IP="127.0.0.1"


# echo $BOOTSTRAP_PUB_KEY
# echo $BOOTSTRAP_IP
# echo $BOOTSTRAP_TCP_PORT
# echo $VALIDATOR_ADDR

set -x



sleep 10

# $HOME/geth --datadir ${DATA_DIR} \
#       --networkid 2200 \
#       --http \
#       --http.addr 0.0.0.0 \
#       --http.port ${HTTP_PORT} \
#       --config ${DATA_DIR}/config.toml \
#       --nousb \
#       --port ${NETWORK_PORT} \
#       --http.corsdomain '*' \
#       --http.api "web3,eth,debug,admin,personal,miner,net" \
#       --ipcpath "${DATA_DIR}/geth.ipc" \
#       --allow-insecure-unlock \
#       --miner.etherbase ${validatorAddr} \
#       --mine \
#       --unlock ${validatorAddr} \
#       --password $DATA_DIR/password.txt \
#       --verbosity 3 \
#       --light.serve 50 \
#       --pprof.addr 0.0.0.0 \
#       --pprof \
#       --syncmode full \
#       --cache 18000 \
#       --maxpeers 21 

$HOME/geth --datadir ${DATA_DIR} \
      --networkid 2200 \
      --http \
      --http.addr 0.0.0.0 \
      --http.port ${HTTP_PORT} \
      --config ${DATA_DIR}/config.toml \
      --nousb \
      --port ${NETWORK_PORT} \
      --http.corsdomain '*' \
      --http.api "web3,eth,debug,admin,personal,miner,net" \
      --ipcpath "${DATA_DIR}/geth.ipc" \
      --miner.etherbase ${validatorAddr} \
      --mine \
      --unlock ${validatorAddr} \
      --password $DATA_DIR/password.txt \
      --verbosity 3 \
      --light.serve 50 \
      --pprof.addr 127.0.0.1 \
      --pprof \
      --syncmode full \
      --allow-insecure-unlock \
      --blspassword ${DATA_DIR}/bls-password.txt
      # --cache 18000 \      
      # --bootnodes "enode://177ae5db445a2f70db781b019aedd928f5b1528a7a43448840b022408f9a21509adcce0b37c87d59da68d47a16879cc1e95a62bbac9723f7b22f4365b2afabbe@192.168.18.130:30305"

      
      
 

