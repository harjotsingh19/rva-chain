#!/bin/bash
set -e

workspace="$HOME/rva-chain"
enodes_array=()

# Define the number of nodes
NUM_NODES=$1

echo "NUM_NODES: $NUM_NODES"



# Read the bootnode key and generate its enode
BOOT_NODEKEY_PATH="$workspace/nodes/rva-rpc/geth/nodekey"
if [[ ! -f "$BOOT_NODEKEY_PATH" ]]; then
    echo "Boot node key file not found!"
    exit 1
fi

BOOT_NODEKEY=$(cat "$BOOT_NODEKEY_PATH")
BOOT_NODE_ENODE=$(bootnode -nodekeyhex "$BOOT_NODEKEY" -writeaddress 2>/dev/null)

if [[ -z "$BOOT_NODE_ENODE" ]]; then
    echo "Failed to extract bootnode enode ID."
    exit 1
fi

BOOT_NODE_ENTRY="\"enode://$BOOT_NODE_ENODE@192.168.29.242:30305\""

# Loop through node identifiers and create/start each node
for i in $(seq 1 $NUM_NODES); do
    NODE_ID="rva-node${i}"
    DATA_DIR="$workspace/nodes-copy/$NODE_ID"

    # Check if the nodekey exists
    if [[ ! -f "$DATA_DIR/geth/nodekey" ]]; then
        echo "Node key file not found for $NODE_ID!"
        continue
    fi

    # Read the node key from the file
    NODEKEY=$(cat "$DATA_DIR/geth/nodekey")

    # Fetch the enode using the nodekey
    ENODE=$(bootnode -nodekeyhex "$NODEKEY" -writeaddress 2>/dev/null)

    echo "ENODE for $NODE_ID :- $ENODE"

    # Check if the enode was successfully fetched
    if [[ -n "$ENODE" ]]; then
        PORT=$((30305 + i))
        ENODE_REPLACED="\"enode://$ENODE@rva-node${i}:$PORT\""
        enodes_array+=("$ENODE_REPLACED")
    else
        echo "Failed to extract enode ID for $NODE_ID."
    fi
done

# Convert array to a properly formatted JSON-like string
enodes_string="[$(IFS=,; echo "${enodes_array[*]}")]"

echo "Final enodes array:"
echo "$enodes_string"

# Loop through nodes to update config files
for i in $(seq 1 $NUM_NODES); do
    NODE_ID="rva-node${i}"
    DATA_DIR="$workspace/nodes-copy/$NODE_ID"
    CONFIG_FILE="./config.toml"

    echo "Updating StaticNodes in $NODE_ID"

    # Update StaticNodes directly
    sed -i -E "s|StaticNodes\s*=\s*\[.*\]|StaticNodes = $enodes_string|" "$CONFIG_FILE"

    # Add ListenAddr with the specific port
    sed -i -E "s|ListenAddr\s*=\s*\".*\"|ListenAddr = \":$((30305 + i))\"|" "$CONFIG_FILE"

       # Replace BootstrapNodes with bootnode entry
    sed -i "s|BootstrapNodes\s*=\s*\[.*\]|BootstrapNodes = [$BOOT_NODE_ENTRY]|" "$CONFIG_FILE"

    echo "Updated config saved to: $CONFIG_FILE"
done