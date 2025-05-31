#!/bin/bash

workspace=$HOME/rva-chain

output_file=${workspace}/files/docker-compose-new-validators.yml

docker-compose -f ${workspace}/files/docker-compose-new-validators.yml down -v






# Number of nodes to create (Hardcoded to 8-10)
START_NODE=8
END_NODE=11

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

# Generate each service configuration for nodes 8 to 10
for i in $(seq $START_NODE $END_NODE)
do
  DATA_DIR="/root/bsc-node"
  HTTP_PORT=8545
  NETWORK_PORT=30305
  NODE_ID="bsc-node${i}"

  echo $((8545 + $i)) $((30305 + $i))*9/784

  sudo rm -rf $workspace/nodes/bsc-node${i}
  

  cp -r $workspace/nodes-backup/bsc-node${i} $workspace/nodes/bsc-node${i}


  cp $HOME/rva-chain/files/config.toml ${workspace}/nodes/bsc-node${i}/config.toml

  # Check if the node is already initialized
  if [ -f "${workspace}/nodes/${NODE_ID}/geth/chaindata/LOCK" ]; then
    echo "Node ${NODE_ID} is already initialized. Skipping initialization."
  else
    echo "Initializing node ${NODE_ID}..."
    ./geth --datadir ${workspace}/nodes/${NODE_ID} init ${workspace}/files/genesis.json
  fi

  # Kill ports if they're already in use
  set -x
  npx kill-port $((8545 + $i)) 
  npx kill-port $((30305 + $i))

  PORT1=$((8545 + i))
  PORT2=$((30305 + i))

  set +x

  cat <<EOF >> $output_file
  node${i}:
    image: hs60/bsc-chain:latest
    container_name: bsc-node${i}
    volumes:
      - ${workspace}/nodes/${NODE_ID}:${DATA_DIR}
      - ./entry-point-new-node.sh:/root/entry-point.sh
      # - ${workspace}/nodes/${NODE_ID}/password.txt:${DATA_DIR}/password.txt

    working_dir: /root
    environment:
      - NETWORK_PORT=$((30305 + $i))
      - HTTP_PORT=$((8545 + $i))
    ports:
      - "$((8545 + $i)):$((8545 + $i))"
      - "$((30305 + $i)):$((30305 + $i))"
    entrypoint: [ "sh", "-c", "/root/entry-point.sh" ]  
    networks:
      - rva_network
EOF

  # Add a newline for separation
  echo >> $output_file
done

echo "Docker Compose file generated at $output_file."

# Copy config.toml to the appropriate node directory
# cp $HOME/rva-chain/files/config.toml ${workspace}/nodes/bsc-node{8,9,10}/config.toml



# Restart docker-compose
docker-compose -f $workspace/files/docker-compose-new-validators.yml down
docker-compose -f $workspace/files/docker-compose-new-validators.yml up -d
