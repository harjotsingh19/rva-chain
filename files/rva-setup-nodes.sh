#!/bin/bash

workspace=$HOME/rva-chain
output_file=${workspace}/files/docker-compose.yml



# docker-compose -f $workspace/files/docker-compose.yml down

# sudo rm -rf $workspace/nodes


# cp -r $workspace/nodes-copy $workspace/nodes


# Number of nodes to create
NUM_NODES=$1

# Start writing the docker-compose.yml file
cat <<EOF > $output_file
version: '3.8'

networks:
  rva_network:
    name: rva-network
# networks:
#   rva_network:
#     driver: bridge

services:
EOF

# Generate each service configuration
for i in $(seq 1 $NUM_NODES)
do

  DATA_DIR="/root/rva-node"
  HTTP_PORT=8545
  NETWORK_PORT=30305
  NODE_ID="rva-node${i}"

  echo $((8545 + $i)) $((30305 + $i))


# cat ${workspace}/nodes/${NODE_ID}/geth/chaindata/LOCK

  # Check if the node is already initialized
if [ -f "${workspace}/nodes/${NODE_ID}/geth/chaindata/LOCK" ]; then
  echo "Node ${NODE_ID} is already initialized. Skipping initialization."
else
  echo "Initializing node ${NODE_ID}..."
  ./geth --datadir ${workspace}/nodes/${NODE_ID} init ${workspace}/files/genesis.json
fi

    

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
  node${i}:
    image: hs60/bsc-chain:latest
    container_name: rva-node${i}
    volumes:
      - ${workspace}/nodes/${NODE_ID}:${DATA_DIR}
      - ./entry-point.sh:/root/entry-point.sh
    working_dir: /root
    environment:
      - NETWORK_PORT=$((30305 + $i))
      - HTTP_PORT=$((8545 + $i))
    ports:
      - "$((8545 + $i)):$((8545 + $i))"
      - "$((30305 + $i)):$((30305 + $i))"
    entrypoint: [ "sh", "-c", "/root/entry-point.sh" ]  
    # network_mode: "host"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:$((30305 + $i))"]
      interval: 30s
      retries: 5
    networks:
      - rva_network
EOF

    # Add a newline for separation
    echo >> $output_file
done

echo "Docker Compose file generated at $output_file."






workspace=$HOME/rva-chain


exit
docker-compose -f $workspace/files/docker-compose.yml down || true

docker-compose -f $workspace/files/docker-compose.yml up -d


exit




docker exec -it rva-node1 /bin/bash

cat /root/rva-node/config.toml

./geth attach /root/rva-node/geth.ipc 

admin.peers

admin.nodeInfo.enode

echo





docker exec -it rva-node2 /bin/bash

cat /root/rva-node/config.toml

./geth attach /root/rva-node/geth.ipc 


admin.peers

admin.nodeInfo.enode


echo

admin.addPeer("enode://6bf80f6f57fca9e15553a8bbb8588952d17e520f8c3fece63b15162f2e90771033fca51220608e55f03108dad179702e99c841bad2766338a952045f2e5f8b0c@127.0.0.1:30306")



docker restart rva-node2

docker restart rva-node1



workspace=$HOME/rva-chain

docker-compose -f $workspace/files/docker-compose.yml down

docker-compose -f $workspace/files/docker-compose.yml up -d