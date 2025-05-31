#!/bin/bash

workspace=$HOME/RVA/bsc-chain

# node_type=bsc-rpc
# node_id=bsc-rpc
# ./geth --datadir ${workspace}/nodes/${node_id} init ${workspace}/genesis/genesis.json

## cpy config.toml file giev below in bsc-rpc boot node dir



# Number of nodes to create
NUM_NODES=$1

# Loop through node identifiers and create/start each node
for i in $(seq 1 $NUM_NODES)
do
    echo "node $i"
 
    NODE_ID="bsc-node$i"

    echo
    echo "COPYING CONFIG FILE"
    echo

    if [ -f "${workspace}/nodes/${NODE_ID}/config.toml" ]; then
    echo "Node ${NODE_ID} is already has initial config.toml, upgrading.............."
    rm -f ${workspace}/nodes/${NODE_ID}/config.toml
    set -x
    cp ./config2.toml ${workspace}/nodes/${NODE_ID}/
    mv ${workspace}/nodes/${NODE_ID}/config2.toml ${workspace}/nodes/${NODE_ID}/config.toml

    set +x
    else
    echo "copying toml file for first time"
    cp ./config.toml ${workspace}/nodes/${NODE_ID}/config-old.toml
    fi

   
done

