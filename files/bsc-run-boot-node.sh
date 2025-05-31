#!/bin/bash

workspace=$HOME/RVA/bsc-chain
output_file=${workspace}/files/docker-compose-boot-node.yml



docker-compose -f $workspace/files/docker-compose-boot-node.yml down

# sudo rm -rf $workspace/nodes/bsc-rpc




# cp -r $workspace/nodes-copy $workspace/nodes


# Number of nodes to create
NUM_NODES=$1

# Start writing the docker-compose-boot-node.yml file
cat <<EOF > $output_file
version: '3.8'

networks:
  bsc_network:
    name: bsc-network
# networks:
#   bsc_network:
#     driver: bridge

services:
EOF

# Generate each service configuration
for i in $(seq 1 $NUM_NODES)
do




  DATA_DIR="/root/bsc-rpc"
  HTTP_PORT=8545
  NETWORK_PORT=30305
  NODE_ID="bsc-rpc"

  echo $((8545 + $i)) $((30305 + $i))


# cat ${workspace}/nodes/${NODE_ID}/geth/chaindata/LOCK

  # Check if the node is already initialized
if [ -f "${workspace}/nodes/${NODE_ID}/geth/chaindata/LOCK" ]; then
  echo "Node ${NODE_ID} is already initialized. Skipping initialization."
else
  echo "Initializing node ${NODE_ID}..."
  ./geth --datadir ${workspace}/nodes/${NODE_ID} init ${workspace}/files/genesis.json
  
fi

sudo rm -rf ${workspace}/nodes/${NODE_ID}/keystore

cp ${workspace}/files/genesis.json ${workspace}/nodes/${NODE_ID}/
# cp -r ${workspace}/files/keystore ${workspace}/nodes/${NODE_ID}/
cp ${workspace}/files/config-rpc.toml ${workspace}/nodes/${NODE_ID}/config.toml

set -x
cp ${workspace}/files/boot.key ${workspace}/nodes/${NODE_ID}/geth/nodekey
    
    set +x

  # sudo fuser -k $((8545 + $i))/tcp $((30305 + $i))/tcp
  set -x

  npx kill-port $((8545 + $i)) 
  npx kill-port $((30305 + $i))




PORT1=$((8545 + i))
PORT2=$((30305 + i))

# # Function to check if a port is in use
# is_port_in_use() {
#     sudo lsof -i :$1 >/dev/null 2>&1
#     return $?
# }

# # Kill port only if it's in use
# if is_port_in_use $PORT1; then
#     # Check if Docker process is using the port and kill it manually
#     sudo lsof -ti :$PORT1 | xargs sudo kill -9
#     echo "Killed process on port $PORT1"
# else
#     echo "Port $PORT1 is not in use, skipping..."
# fi

# if is_port_in_use $PORT2; then
#     # Check if Docker process is using the port and kill it manually
#     sudo lsof -ti :$PORT22| xargs sudo kill -9
#     echo "Killed process on port $PORT1"
# else
#     echo "Port $PORT2 is not in use, skipping..."
# fi


set +x

    cat <<EOF >> $output_file
  bsc-rpc:
    image: hs60/bsc-chain:latest
    container_name: bsc-rpc
    volumes:
      - ${workspace}/nodes/${NODE_ID}:${DATA_DIR}
      - ./bsc-rpc.sh:/root/bsc-rpc.sh
    working_dir: /root
    environment:
      - NETWORK_PORT=30305
      - HTTP_PORT=8545
    ports:
      - 8545:8545
      - 30305:30305
    entrypoint: [ "sh", "-c", "/root/bsc-rpc.sh" ]  
    # network_mode: "host"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:30305"]
      interval: 30s
      retries: 5
    networks:
      - bsc_network
EOF

    # Add a newline for separation
    echo >> $output_file
done

echo "Docker Compose file generated at $output_file."






workspace=$HOME/RVA/bsc-chain



docker-compose -f $workspace/files/docker-compose-boot-node.yml down

docker-compose -f $workspace/files/docker-compose-boot-node.yml up -d


exit




docker exec -it bsc-rpc1 /bin/bash

cat /root/bsc-rpc/config.toml

./geth attach /root/bsc-rpc/geth.ipc 

admin.peers

admin.nodeInfo.enode

echo





docker exec -it bsc-rpc2 /bin/bash

cat /root/bsc-rpc/config.toml

./geth attach /root/bsc-rpc/geth.ipc 


admin.peers

admin.nodeInfo.enode


echo

admin.addPeer("enode://6bf80f6f57fca9e15553a8bbb8588952d17e520f8c3fece63b15162f2e90771033fca51220608e55f03108dad179702e99c841bad2766338a952045f2e5f8b0c@127.0.0.1:30306")



docker restart bsc-rpc2

docker restart bsc-rpc1



workspace=$HOME/RVA/bsc-chain

docker-compose -f $workspace/files/docker-compose-boot-node.yml down

docker-compose -f $workspace/files/docker-compose-boot-node.yml up -d