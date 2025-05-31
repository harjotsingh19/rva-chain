#!/bin/bash

workspace="/root"
DATA_DIR="/root/bsc-node"
# HTTP_PORT=8545
# NETWORK_PORT=30305
NODE_ID="bsc-node"


cat ${workspace}/${NODE_ID}/address

validatorAddr=$(cat ${workspace}/${NODE_ID}/address)

echo "validator addres $validatorAddr"


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

# $HOME/geth --datadir ${DATA_DIR} \
#       --networkid 2200 \
#       --http \
#       --http.addr 0.0.0.0 \
#       --http.port ${HTTP_PORT} \
#       --config ${DATA_DIR}/config.toml \
#       --nousb \
#       --port ${NETWORK_PORT} \
#       --http.corsdomain '*' \
#       --http.api web3,eth,debug,admin,personal,miner,net \
#       --ipcpath "${DATA_DIR}/geth.ipc" \
#       --allow-insecure-unlock \
#       --password /dev/null \
#       --verbosity 3 \
#       --light.serve 50 --pprof.addr 0.0.0.0 \
#       --pprof \
#       --syncmode=full --cache=4096 --maxpeers=21 --monitor.doublesign

# $HOME/geth --datadir ${DATA_DIR} \
#       --networkid 2200 \
#       --http \
#       --http.addr 0.0.0.0 \
#       --http.port ${HTTP_PORT} \
#       --config ${DATA_DIR}/config.toml \
#       --nousb \
#       --port ${NETWORK_PORT} \
#       --http.corsdomain '*' \
#       --http.api web3,eth,debug,admin,personal,miner,net \
#       --ipcpath "${DATA_DIR}/geth.ipc" \
#       --allow-insecure-unlock \
#       --miner.etherbase ${validatorAddr} \
#       --mine \
#       -unlock ${validatorAddr} \
#       --password /dev/null \
#       --verbosity 3 \
#       --light.serve 50 --pprof.addr 0.0.0.0 \
#       --pprof \
#       --syncmode=full --cache=4096 --maxpeers=21 --monitor.doublesign
      

  cat "file is $DATA_DIR/blspassword.txt"    

#  $HOME/geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --syncmode snap --password $DATA_DIR/password.txt --blspassword ${DATA_DIR}/bls-password.txt  --allow-insecure-unlock --cache 18000 --networkid 2200 \
#       --http \
#       --http.addr 0.0.0.0 \
#       --http.port ${HTTP_PORT} \
#       --nousb \
#       --port ${NETWORK_PORT} \
#       --http.corsdomain '*' \
#       --http.api web3,eth,debug,admin,personal,miner,net \
#       --ipcpath "${DATA_DIR}/geth.ipc" \
#       --verbosity 3 \
#       --light.serve 50 --pprof.addr 0.0.0.0 \
#       --pprof \
#       --monitor.doublesign \
#       --mine \
#       -unlock ${validatorAddr} --miner.etherbase ${validatorAddr} \
#       --vote --nodiscover


   $HOME/geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --syncmode snap --password $DATA_DIR/password.txt --blspassword ${DATA_DIR}/bls-password.txt --networkid 2200 \
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
      # --cache 18000
      # --syncmode=full
            
     
      # --maxpeers 0


# geth --networkid 56 --port 30307 --http --http.addr 0.0.0.0 --ws --ws.addr 0.0.0.0 --syncmode full --allow-insecure-unlock


# $HOME/geth --datadir ${DATA_DIR} \
#       --networkid 2200 \
#       --http \
#       --http.addr 0.0.0.0 \
#       --http.port ${HTTP_PORT} \
#       --nousb \
#       --port ${NETWORK_PORT} \
#       --http.corsdomain '*' \
#       --http.api web3,eth,debug,admin,personal,miner,net \
#       --ipcpath "${DATA_DIR}/geth.ipc" \
#       --allow-insecure-unlock \
#       --miner.etherbase ${validatorAddr} \
#       --mine \
#       -unlock ${validatorAddr} \
#       --password /dev/null \
#       --verbosity ${VERBOSE} \
#       --light.serve 50 --pprof.addr 0.0.0.0 \
#       --pprof \
#       --bootnodes enode://260631717923ac6dfc8868f7b18f934940441627c5517c9e80c7d1bae7b1a5cef408776b00b02810b5cd5f245e6935dbfd5fc767e9553c2d1e44278f81c13888@127.0.0.1:30306,enode://6ff61bfcaf9fc6354c2caf290fac0a19f704cbd1df5d746bdf3a8804b9102ebd1fa2529ce9832069cff6b014d37d22a1aeb7079efa1cf8054e6c9e833e1e3655@127.0.0.1:30307,enode://21f2087325251d0b7d55d991de3b39ee471cd744a7e38d784f6b2f6d43ec3f364e4516cf996b9885955c3bde4b9e94e08e97e1d3c0bdad1f1c8794f3ee912333@127.0.0.1:30308

# $HOME/geth --datadir ${DATA_DIR} --verbosity ${VERBOSE} --nousb --bootnodes enode://${BOOTSTRAP_PUB_KEY}@${BOOTSTRAP_IP}:${BOOTSTRAP_TCP_PORT} \
# --miner.etherbase "$validatorAddr" --mine -unlock ${validatorAddr} --password /dev/null \
# --light.serve 50 --pprof.addr 0.0.0.0 --metrics \
# --rpc.allow-unprotected-txs --txlookuplimit  15768000 \
# --pprof --nodiscover    



# ./geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} --verbosity ${VERBOSE} --nousb --bootnodes enode://${BOOTSTRAP_PUB_KEY}@${BOOTSTRAP_IP}:${BOOTSTRAP_TCP_PORT} \
# --miner.etherbase "$VALIDATOR_ADDR" --mine -unlock ${VALIDATOR_ADDR} --password /dev/null \
# --light.serve 50 --pprof.addr 0.0.0.0 --metrics \
# --rpc.allow-unprotected-txs --txlookuplimit  15768000 \
# --pprof

set +x
