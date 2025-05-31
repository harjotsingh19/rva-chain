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
    DATA_DIR="$workspace/nodes/$NODE_ID"

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
    if [[ -z "$ENODE" ]]; then
        echo "Failed to extract enode ID from the node key for $NODE_ID."
    else
        PORT=$((30305 + i))
        ENODE_REPLACED="\"enode://$ENODE@rva-node${i}:$PORT\""
        enodes_array+=("$ENODE_REPLACED")
    fi
done

# Convert array to comma-separated string
enodes_string=$(IFS=,; echo "${enodes_array[*]}")

echo "Final enodes array:"
echo "[$enodes_string]"

# Loop through nodes to update config files
for i in $(seq 1 $NUM_NODES); do
    NODE_ID="rva-node${i}"
    DATA_DIR="$workspace/nodes/$NODE_ID"
    INPUT_FILE="$DATA_DIR/config-old.toml"
    OUTPUT_FILE="$DATA_DIR/config.toml"

    echo "Updating StaticNodes and BootstrapNodes in $NODE_ID excluding its own entry"

    # Exclude the current node's entry from StaticNodes
    filtered_enodes=$(echo "$enodes_string" | sed "s/\"enode:\/\/[^\"]*@rva-node${i}:[0-9]\+\"//g")

    # Remove redundant commas (e.g. ,, to ,)
    filtered_enodes=$(echo "$filtered_enodes" | sed 's/,,/,/g')

    # Ensure no leading or trailing commas
    filtered_enodes=$(echo "$filtered_enodes" | sed 's/^[,]*//')  # Remove leading commas
    filtered_enodes=$(echo "$filtered_enodes" | sed 's/[,]$//')  # Remove trailing commas

    # Ensure the list is enclosed in brackets
    filtered_enodes="[$filtered_enodes]"

    # Replace StaticNodes array in config.toml
    sed -E "s|StaticNodes\s*=\s*\[.*\]|StaticNodes = $filtered_enodes|" "$INPUT_FILE" > "$OUTPUT_FILE"

    # Add ListenAddr with the specific port
    sed -i "s|ListenAddr = \"\"|ListenAddr = \":$((30305 + i))\"|" "$OUTPUT_FILE"

    # Replace BootstrapNodes with bootnode entry
    sed -i "s|BootstrapNodes\s*=\s*\[.*\]|BootstrapNodes = [$BOOT_NODE_ENTRY]|" "$OUTPUT_FILE"

    echo "Updated config saved to: $OUTPUT_FILE"
done