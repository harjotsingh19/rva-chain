#!/bin/bash

workspace=$HOME/RVA/bsc-chain

# Number of nodes to create (set to 5)
NUM_NODES=5

# Clear previous nodes and backups
sudo rm -rf ${workspace}/nodes
sudo rm -rf ${workspace}/nodes-backup

# Create a new directory for nodes

cp -r ${workspace}/nodes-backup2 ${workspace}/nodes

# Loop to create nodes
for i in $(seq 1 $NUM_NODES)
do
    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    mkdir -p $DATA_DIR

    # Create a new account for the node
    # ./geth account new --datadir ${DATA_DIR} --password /dev/null > ${workspace}/nodes/${NODE_ID}Info

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"

    # Write the validator address to validators.conf
    echo "${validatorAddr},${validatorAddr},${validatorAddr},0x0000000010000000" >> ${workspace}/genesis/validators.conf
    echo ${validatorAddr} > ${workspace}/nodes/${NODE_ID}/address

    # Create a new BLS account for the node
    ./geth bls account new --datadir ${DATA_DIR}

    # # Get the vote address for the node
    # VOTE_ADDRESS=$(./geth bls account list --datadir ${DATA_DIR} | awk '{print $1}' | head -n 1)
    # echo "Vote address for node ${i}: $VOTE_ADDRESS"

    # # Set BSC Chain ID and operator address for proof generation
    # BSC_CHAIN_ID=2200
    # OPERATOR_ADDRESS="$validatorAddr"

    # # Generate BLS proof for the node
    # ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}
done


echo "COPYING ..................."
echo

cp -r ${workspace}/nodes ${workspace}/nodes-backup

echo 
echo "..........................."
exit


    i=1


    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"


    # Get the vote address for the node
    ./geth bls account list --datadir ${DATA_DIR}


    # Set BSC Chain ID and operator address for proof generation
    BSC_CHAIN_ID=2200
    OPERATOR_ADDRESS=$validatorAddr
    VOTE_ADDRESS="0xb0f488568f9a2eb58ce478eb36efef6f680b0ccd8fe223e76a21242d3698315eb50c5ff215b3be9778a143d86f076d0f"

    # Generate BLS proof for the node
    ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}

    BLS="0x97ae0ffddd7988b5253185bc5f2e8633e4c7c2fe69e55f687c319fc6ba96bf89c7a5a37b24f1f09d3d87a05bd1a90cee0404352bb4c05fcfb8ae9419e611021018642c848a59a7c5f996324c490a25089674fa9564e7397f6e03f3ae42953d62"




    i=2


    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"


    # Get the vote address for the node
    ./geth bls account list --datadir ${DATA_DIR}


    # Set BSC Chain ID and operator address for proof generation
    BSC_CHAIN_ID=2200
    OPEATOR_ADDRESS=$validatorAddr
    VOTE_ADDRESS="0x862f759a3772902837a739b3d8b107e03429e15c3b94a86e01629b180c8296ad5b0a3f0521b7f55b3c18ce10c8875e84"

    # Generate BLS proof for the node
    ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}

    BLS="0x90266a35ce8a0f0104d719b034a1e0faa40f2c61a0abf8fe0695d0c8e4db7e50a26bcabf57d0b4b7743fc9d1616ab26e066b7efeb0ed38102db010009aa1668e542c38ef60016d91ef65daeb277e0de81d29d2eb1380164e2530be1ced203db4"



    i=3


    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"


    # Get the vote address for the node
    ./geth bls account list --datadir ${DATA_DIR}


    # Set BSC Chain ID and operator address for proof generation
    BSC_CHAIN_ID=2200
    OPEATOR_ADDRESS=$validatorAddr
    VOTE_ADDRESS="0x8e7ed873b208fab0965661e024964733857b577267015805f89c7586b78857749de22690c9f35251bf51f18658cf815e"

    # Generate BLS proof for the node
    ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}

    BLS="0xaff412370c829da25ab34ef7842e48ce99fd260ee092bcb735a132e95780c89aea1e25180a049441f5972633640d99b416047abbfdce2b430cf7c4794b5c383644eecc600fb89c86f78e0c72c611b4ace48fb1180ffa920c5aafe55aa7203980"



    i=4


    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"


    # Get the vote address for the node
    ./geth bls account list --datadir ${DATA_DIR}


    # Set BSC Chain ID and operator address for proof generation
    BSC_CHAIN_ID=2200
    OPEATOR_ADDRESS=$validatorAddr
    VOTE_ADDRESS="0xadfc1fece99f64ee48b9cf04fb9ad11906ac69572b941c2afe861ca5db79d3b01c66d78a6716953cab426b8ad2325d2f"

    # Generate BLS proof for the node
    ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}

    BLS="0xa6a0ee7116d0a077f8d0fc0175df326b24c55f57d09c5d59f4ea3feb7b90acb4d279d687a33da925fd80b2819d7f4bde13433d041df1ea6345433370cda4902a04552755c746c2eac234ed3f08868cfd9b015b65de7e6f540ca8a7a2ff007431"



    i=5


    NODE_ID="bsc-node${i}"
    DATA_DIR=${workspace}/nodes/${NODE_ID}

    echo "Creating node directory: $DATA_DIR"

    # Extract the validator address from the account info
    validatorAddr=$(grep 'Public address of the key' ${workspace}/nodes/${NODE_ID}Info | awk '{print $6}')
    echo "Validator address for node ${i}: $validatorAddr"


    # Get the vote address for the node
    ./geth bls account list --datadir ${DATA_DIR}


    # Set BSC Chain ID and operator address for proof generation
    BSC_CHAIN_ID=2200
    OPEATOR_ADDRESS=$validatorAddr
    VOTE_ADDRESS="0x8e3dcbaa84953cd4467d68abca61d69ba870292d523b58379c2d3f36d08827bd0896b56ba23e93bb52e08031ac3e19ad"

    # Generate BLS proof for the node
    ./geth bls account generate-proof --datadir ${DATA_DIR} --chain-id ${BSC_CHAIN_ID} ${OPERATOR_ADDRESS} ${VOTE_ADDRESS}

    BLS="0xa000d83a3a745a9ef9c15c716946a33fc3a99398370dc820242cf0008b16cc9d65f46cb7bb9006e50195cdc1c6345744175020fac9eee26f1a9bd7550170badcce24f736ddb8980748ad08842e0a5765043b3850528ee1dba08a35a940677f2d"

# Backup the nodes
cp -r ${workspace}/nodes ${workspace}/nodes-backup

echo "Finished creating and configuring $NUM_NODES nodes."
