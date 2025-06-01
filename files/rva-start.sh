
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
