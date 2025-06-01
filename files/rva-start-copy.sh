
set -euo pipefail
trap 'echo "❌ Script failed on line $LINENO. Press any key to exit..."; read' ERR


workspace=$HOME/rva-chain/files

NUM_NODES=5

BALANCE=30000000000000000000000000

$workspace/rva-generate-nodes.sh $NUM_NODES $BALANCE

$workspace/bsc-genesis-contract.sh



# Set workspace path
workspace=$HOME/rva-chain/files
cd $HOME/RVA/bsc-chain/files || exit 1

docker-compose -f $workspace/docker-compose.yml down -v || true

docker-compose -f $workspace/docker-compose-new-validators.yml down -v || true

docker-compose -f $workspace/docker-compose-boot-node.yml down -v || true

sudo rm -rf $workspace/../nodes || true

sudo rm -rf $workspace/../nodes-copy || true

cp -r $workspace/../nodes-backup $workspace/../nodes || true

# Set number of validator nodes
NUM_NODES=5

echo "🚀 Running boot node..."
$workspace/rva-run-boot-node.sh 1

echo "🔧 Setting up $NUM_NODES validator nodes..."
$workspace/rva-setup-nodes.sh $NUM_NODES

# echo "📡 Fetching enode addresses..."
# for i in $(seq 1 $NUM_NODES); do
#     NODE_KEY_PATH="$workspace/../nodes/rva-node$i/geth/nodekey"
#     if [[ ! -f "$NODE_KEY_PATH" ]]; then
#         echo "❌ Node key not found for rva-node$i"
#         continue
#     fi
#     NODE_KEY=$(cat "$NODE_KEY_PATH")
#     NODE_ENODE=$(bootnode -nodekeyhex "$NODE_KEY" -writeaddress 2>/dev/null)
#     echo "rva-node$i => $NODE_ENODE"
# done

echo "⚙️ Creating config.toml files..."
$workspace/rva-config-setup.sh $NUM_NODES

echo "🔑 Fetching validator keys..."
$workspace/rva-fetch-keys.sh $NUM_NODES
$workspace/rva-fetch-key2.sh $NUM_NODES

echo "🐳 Starting nodes with Docker Compose..."

docker-compose -f $workspace/docker-compose.yml down -v || true

docker-compose -f $workspace/docker-compose.yml up -d

docker restart rva-node1


echo "✅ All done!"


exit


cd $HOME/rva-chain/files


## start from scratch

workspace=$HOME/rva-chain

cd $HOME/rva-chain/files

docker-compose -f $workspace/files/docker-compose.yml down -v || true

docker-compose -f $workspace/files/docker-compose-new-validators.yml down -v || true

docker-compose -f $workspace/files/docker-compose-boot-node.yml down -v || true
  
# docker-compose -f $workspace/files/docker-compose-full-node.yml down -v

# sudo rm -rf $workspace/nodes $workspace/nodes-compare
sudo rm -rf $workspace/nodes $workspace/nodes-copy || true

cp -r $workspace/nodes-backup $workspace/nodes || true

file_path="$workspace/nodes/rva-node1/address"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "File does not exist: $file_path"
    exit 1
else
    echo "File exists. Proceeding with further execution..."
    # Your subsequent commands go here
fi

# docker-compose -f $workspace/files/docker-compose-boot-node.yml down

# cp -r $workspace/nodes-compare $workspace/nodes


num=5


./rva-run-boot-node.sh 1


# docker-compose -f $workspace/files/docker-compose-boot-node.yml down

# docker-compose -f $workspace/files/docker-compose-boot-node.yml up -d

echo

./rva-setup-nodes.sh $num




./rva-config-setup.sh $num


sudo rsync -a "$workspace/nodes/" "$workspace/nodes-copy/"

#  sudo rsync -a "$workspace/nodes/" "$workspace/nodes-runnig/"

# cp -r $workspace/nodes $workspace/nodes-compare


./rva-fetch-keys.sh $num

./rva-fetch-key2.sh $num

echo


workspace=$HOME/rva-chain

# docker-compose -f $workspace/files/docker-compose.yml down -v

# docker-compose -f $workspace/files/docker-compose-new-validator.yml down -v

# docker-compose -f $workspace/files/docker-compose-new-validator2.yml down -v

docker-compose -f $workspace/files/docker-compose.yml up -d


echo

docker restart bsc-node1

exit





#!/bin/bash

# Set workspace path
workspace=$HOME/rva-chain/files
cd $HOME/RVA/bsc-chain/files || exit 1

docker-compose -f $workspace/docker-compose.yml down -v

sudo rm -rf $workspace/../nodes || true

sudo rm -rf $workspace/../nodes-copy || true

cp -r $workspace/../nodes-backup $workspace/../nodes || true

# Set number of validator nodes
NUM_NODES=5

echo "🚀 Running boot node..."
$workspace/rva-run-boot-node.sh 1

echo "🔧 Setting up $NUM_NODES validator nodes..."
$workspace/rva-setup-nodes.sh $NUM_NODES

# echo "📡 Fetching enode addresses..."
# for i in $(seq 1 $NUM_NODES); do
#     NODE_KEY_PATH="$workspace/../nodes/rva-node$i/geth/nodekey"
#     if [[ ! -f "$NODE_KEY_PATH" ]]; then
#         echo "❌ Node key not found for rva-node$i"
#         continue
#     fi
#     NODE_KEY=$(cat "$NODE_KEY_PATH")
#     NODE_ENODE=$(bootnode -nodekeyhex "$NODE_KEY" -writeaddress 2>/dev/null)
#     echo "rva-node$i => $NODE_ENODE"
# done

echo "⚙️ Creating config.toml files..."
$workspace/rva-config-setup.sh $NUM_NODES

echo "🔑 Fetching validator keys..."
$workspace/rva-fetch-keys.sh $NUM_NODES
$workspace/rva-fetch-key2.sh $NUM_NODES

echo "🐳 Starting nodes with Docker Compose..."

docker-compose -f $workspace/docker-compose.yml down -v

docker-compose -f $workspace/docker-compose.yml up -d

docker restart rva-node1


echo "✅ All done!"




docker restart bsc-rpc bsc-node1 bsc-node2 bsc-node3 bsc-node4 bsc-node5 bsc-node6


zip -r bsc-server.zip ./ -x  "*/node_modules/*"

zip -r bsc-server.zip ./ -x "nodes/*" "files/*" "node_modules/*"


exit

echo

sleep 2


./bsc-run-full-node.sh

./bsc-run-new-node2.sh 1

echo 

exit

docker-compose -f $workspace/files/docker-compose.yml down -v

sleep 3

docker-compose -f $workspace/files/docker-compose.yml up -d


sleep 5

docker restart bsc-node3


echo


exit
./bsc-fetch-enode-entries.sh

echo

docker-compose -f $workspace/files/docker-compose.yml down -v

echo

./bsc-delete-files.sh


./bsc-config-setup.sh

echo

./bsc-start.sh

echo




docker exec -it bsc-node1 /bin/bash

cat /root/bsc-node/config.toml

./geth attach /root/bsc-node/geth.ipc 

admin.peers

admin.nodeInfo.enode

echo





docker exec -it bsc-node2 /bin/bash

cat /root/bsc-node/config.toml

./geth attach /root/bsc-node/geth.ipc 


admin.peers

admin.nodeInfo.enode


echo

admin.addPeer("enode://6bf80f6f57fca9e15553a8bbb8588952d17e520f8c3fece63b15162f2e90771033fca51220608e55f03108dad179702e99c841bad2766338a952045f2e5f8b0c@127.0.0.1:30306")



docker restart bsc-node2

docker restart bsc-node1



workspace=$HOME/rva-chain

docker-compose -f $workspace/files/docker-compose.yml down

docker-compose -f $workspace/files/docker-compose.yml up -d





cd ~/RVA/bsc-chain/web3-app && node index.js

cd ~/RVA/bsc-chain/web3-app && node validator-balance.js

cd ~/RVA/bsc-chain/web3-app && node create-validator.js

cd ~/RVA/bsc-chain/web3-app && node get-validators.js

cd ~/RVA/bsc-chain/validator-scripts && node update-validator.js

cd ~/RVA/bsc-chain/validator-scripts && node server2.js



./geth attach http://localhost:8546

eth.getTransaction("0x0cfb1d75f41ec13f1ec4cd35a925a6e49407fd9431b36cace15c636c195eb8be")






docker-compose -f $workspace/files/docker-compose.yml down -v

docker-compose -f $workspace/files/docker-compose-new-validator.yml down -v

docker-compose -f $workspace/files/docker-compose-new-validator2.yml down -v

docker-compose -f $workspace/files/docker-compose-boot-node.yml down


workspace=$HOME/rva-chain

cd $workspace/files


docker-compose -f $workspace/files/docker-compose-boot-node.yml up -d

docker-compose -f $workspace/files/docker-compose.yml up -d

docker-compose -f $workspace/files/docker-compose-new-validators.yml up -d

docker restart bsc-node1 bsc-node2 bsc-node3 bsc-node8 bsc-node9 bsc-node10 bsc-node11





docker-compose -f $workspace/files/docker-compose-new-validator.yml up -d

docker-compose -f $workspace/files/docker-compose-new-validator2.yml up -d

docker-compose -f $workspace/files/docker-compose-new-validator3.yml up -d

docker-compose -f $workspace/files/docker-compose-new-validator4.yml up -d


docker-compose -f $workspace/files/docker-compose-boot-node.yml up -d

sleep 40

docker-compose -f $workspace/files/docker-compose.yml up -d

echo

sleep 30

docker-compose -f $workspace/files/docker-compose-new-validator.yml down

docker-compose -f $workspace/files/docker-compose-new-validator.yml up -d



./geth attach http://127.0.0.1:8546

admin.peers




node balance-send-new-validator1.js

node balance-send-new-validator2.js

node balance-send-new-validator3.js

node balance-send-new-validator4.js

node create-node1-validator.js

node create-node2-validator.js

node create-node3-validator.js

node create-validator.js

node create-validator2.js

node create-validator3.js

node create-validator4.js