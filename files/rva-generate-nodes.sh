#!/bin/bash

# Set workspace directory
workspace=$HOME/rva-chain
validators=$1

# Number of nodes to create
NUM_NODES=$validators
sudo rm -rf ${workspace}/nodes
sudo rm -rf ${workspace}/nodes-backup

rm -rf ${workspace}/nodes-accounts
mkdir -p ${workspace}/nodes-accounts

validators_array="const web3 = require('web3');\nconst RLP = require('rlp');\n\n// Configure\nconst validators = ["
bLSPublicKeys="const bLSPublicKeys = ["
init_holders="const init_holders = ["

# Base balance value
# BASE_BALANCE="20000000000000000000000000"
BASE_BALANCE=$2

# Loop through node identifiers and create/start each node
for i in $(seq 1 $NUM_NODES); do
    echo "node $i"

    NODE_ID="rva-node$i"
    mkdir -p ${workspace}/nodes/${NODE_ID}
    mkdir -p ${workspace}/nodes/rva-rpc/keystore

    # Generate unique password for each account (e.g., node1@rva, node2@rva)
    PASSWORD="node${i}@rva"
    BLS_PASSWORD="node${i}bls@rva"

    # Write the password to a temporary file
    PASSWORD_FILE="${workspace}/nodes/${NODE_ID}/password.txt"
    echo $PASSWORD > $PASSWORD_FILE

    # Generate account with unique password
    ./geth --datadir ${workspace}/nodes/${NODE_ID} account new --password $PASSWORD_FILE > ${workspace}/nodes/${NODE_ID}Info

    # Clean up the temporary password file
    # rm $PASSWORD_FILE

    DATA_DIR=${workspace}/nodes/${NODE_ID}
    # Extract public address
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')

    echo $validatorAddr  
    echo "${validatorAddr},${validatorAddr},${validatorAddr},0x0000000010000000" >> ${workspace}/genesis/validators.conf
    echo ${validatorAddr} > ${workspace}/nodes/${NODE_ID}/address

    set -x

    mkdir -p ${workspace}/nodes-accounts/${NODE_ID}

    cp -r ${workspace}/nodes/${NODE_ID}/* ${workspace}/nodes-accounts/${NODE_ID}

    cp -r ${workspace}/nodes/${NODE_ID}Info ${workspace}/nodes-accounts/${NODE_ID}Info

    set +x

    BLS_PASSWORD_FILE="${workspace}/nodes/${NODE_ID}/bls-password.txt"
    echo $BLS_PASSWORD > $BLS_PASSWORD_FILE

    echo "BLS PASSWORD $BLS_PASSWORD_FILE"

    ./geth bls account new --datadir ${workspace}/nodes/${NODE_ID} --blspassword $BLS_PASSWORD_FILE

    # Run the command and store the output in a file
    ./geth bls account list --datadir ${workspace}/nodes/${NODE_ID} --blspassword ${workspace}/nodes/${NODE_ID}/bls-password.txt > ${workspace}/nodes/${NODE_ID}/vote_address.txt

    # Debugging output (to check the full raw output file)
    echo "Full output written to vote_address.txt"

    # Define the file path
    file_path="${workspace}/nodes/${NODE_ID}/vote_address.txt"

    # Use grep with a regular expression to extract the string starting with '0x'
    VOTE_ADDRESS=$(grep -oE '0x[a-fA-F0-9]+' "$file_path")

    # Check if a match was found and print it
    if [ -n "$VOTE_ADDRESS" ]; then
        echo "Extracted value: $VOTE_ADDRESS"
    else
        echo "No BLS public key found."
    fi

    echo ${VOTE_ADDRESS} > ${workspace}/nodes/${NODE_ID}/vote_address.txt
    
    RVA_CHAIN_ID=2200
    OPERATOR_ADDRESS=$validatorAddr

    # Run the command and capture the output
    BLS_PROOF=$(./geth bls account generate-proof --datadir "$workspace/nodes/$NODE_ID" --blspassword "$BLS_PASSWORD_FILE" --chain-id "$RVA_CHAIN_ID" "$OPERATOR_ADDRESS" "$VOTE_ADDRESS")

    # Extract the proof value (assuming it’s the last token in the output)
    proof_value=$(echo "$BLS_PROOF" | grep -oE '0x[a-fA-F0-9]+' | tail -n 1)

    # Store the proof value in BLS_PROOF variable
    if [ -n "$proof_value" ]; then
        BLS_PROOF=$proof_value
        echo "BLS Proof stored: $BLS_PROOF"
    else
        echo "No proof found in the output."
    fi

    echo ${BLS_PROOF} > ${workspace}/nodes/${NODE_ID}/bls_proof.txt

    set +x

    # Copy keystore files
    SOURCE_DIR="${workspace}/nodes/${NODE_ID}/keystore"
    DEST_DIR="${workspace}/nodes/rva-rpc/keystore/${validatorAddr}"

    mkdir -p "$DEST_DIR"

    for file in "$SOURCE_DIR"/*; do
        if [ -f "$file" ]; then
            cp "$file" "$DEST_DIR"
        fi
    done

    # Calculate unique balance and voting power using bc for large numbers
    BALANCE=$(echo "$BASE_BALANCE + $i*100" | bc)
    echo "Base Balance: $BASE_BALANCE, i: $i"
    echo "BALANCE: $BALANCE"

    VOTING_POWER="0x0000000000000064"  # Unique voting power (hex format)

    # Append validator info with correct JavaScript format
    validators_array+="
    {
        consensusAddr: '$validatorAddr',
        feeAddr: '$validatorAddr',
        bscFeeAddr: '$validatorAddr',
        votingPower: $VOTING_POWER,
    },"

    # Append vote address to bLSPublicKeys
    bLSPublicKeys+="
    '$VOTE_ADDRESS',
    "

    # Append holder info to init_holders
    init_holders+="
    {
        address: '$validatorAddr',
        balance: BigInt('$BALANCE').toString(16),
    },"
done

# Remove trailing commas and close arrays
validators_array="${validators_array%,}
];"

bLSPublicKeys="${bLSPublicKeys%,}
];"

init_holders="${init_holders%,}
];"

# Write the validators.js file
echo -e "$validators_array\n\n$bLSPublicKeys" > ${workspace}/genesis-nodes-files/validators.js

# Append the required functions after bLSPublicKeys in validators.js
cat << 'EOF' >> ${workspace}/genesis-nodes-files/validators.js

// ======== Do not edit below ========
function generateExtraData(validators) {
  let extraVanity = Buffer.alloc(32);
  let validatorsBytes = extraDataSerialize(validators);
  let extraSeal = Buffer.alloc(65);
  return Buffer.concat([extraVanity, validatorsBytes, extraSeal]);
}

function extraDataSerialize(validators) {
  let n = validators.length;
  let arr = [];
  for (let i = 0; i < n; i++) {
    let validator = validators[i];
    arr.push(Buffer.from(web3.utils.hexToBytes(validator.consensusAddr)));
  }
  return Buffer.concat(arr);
}

function validatorUpdateRlpEncode(validators, bLSPublicKeys) {
  let n = validators.length;
  let vals = [];
  for (let i = 0; i < n; i++) {
    vals.push([
      validators[i].consensusAddr,
      validators[i].bscFeeAddr,
      validators[i].feeAddr,
      validators[i].votingPower,
      bLSPublicKeys[i],
    ]);
  }
  let pkg = [0x00, vals];
  return web3.utils.bytesToHex(RLP.encode(pkg));
}

extraValidatorBytes = generateExtraData(validators);
validatorSetBytes = validatorUpdateRlpEncode(validators, bLSPublicKeys);

exports = module.exports = {
  extraValidatorBytes: extraValidatorBytes,
  validatorSetBytes: validatorSetBytes,
};
EOF

# Write the init_holders.js file
echo -e "$init_holders" > ${workspace}/genesis-nodes-files/init_holders.js

set -x
cp -r ${workspace}/nodes ${workspace}/nodes-backup
set +x

echo "✅ Node generation completed successfully!"
