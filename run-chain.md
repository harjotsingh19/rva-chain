
  

# SETUP NETWORK

  

## Clone the repo

`cd $HOME`

  

`git clone https://github.com/harjotsingh19/rva-chain.git`

  

- Move to cloned directory

`cd $HOME/rva-chain/files`

  

## Create N numbers of initial nodes

  

- Set the workspace

`workspace=$HOME/rva-chain/files`

- set the initial number of validator nodes and their initial balance below

`NUM_NODES=5`

`BALANCE="300000000000000000000000000"`

- Now run the file to generate directory of each initial node

  

`$workspace/rva-generate-nodes.sh $NUM_NODES $BALANCE`

  

- The above command will also generate init-holders.js and validator.js files that will replace init-holders.js and validator.js in bsc-genesis-contract repo scripts

  
  

`sudo rm -rf $workspace/nodes $workspace/nodes-copy`

  
  

`cp -r $workspace/nodes-backup $workspace/nodes`

  

## Change the number of INIT_NUM_OF_CABINET

- Change INIT_NUM_OF_CABINET in $HOME/rva-chain/genesis-nodes-files/BSCValidatorSet.sol

  

## Generate genesis file using already cloned BSC genesis contract repo

This script will create bsc chain original bsc-genesis-contract repo to be edited , install foundry and install poetry , copy and replace init-holders.js , validator.js ,generate.py,generate-genesis.js (you can change chain id in it ),package.json (changed epoch,block-interval, etc configuration) and BSCValidatorSet.sol from $HOME/rva-chain/genesis-nodes-files to $HOME/rva-chain/bsc-genesis-contract/scripts and then generate new genesis.json and copy it to $HOME/rva-chain/files/genesis.json to be used to initialize nodes.

  

`$workspace/bsc-genesis-contract.sh`

  

## Now run the commands to setup boot node and other initial validator nodes and run the chain

- Setup workspace

  

`workspace=$HOME/rva-chain/files`

`cd $HOME/RVA/bsc-chain/files`

  

- Run the boot node with genesis.json generated using contract.sh file

`$workspace/rva-run-boot-node.sh 1`

- Setup same number of nodes again in constant NUM_NODES e.g. 5

`NUM_NODES=5`

  

- Initialize the validator node with generated genesis.json

`$workspace/rva-setup-nodes.sh $NUM_NODES`

  

- Now fetch and write down enode address of each node using commands for each node:-

Run these commands for boot node and each node by changing their `$workspace/../nodes/rva-<node_name>/geth/nodekey` path

  

`NODE_KEY_PATH="$workspace/../nodes/rva-node1/geth/nodekey"`

  

`NODE_KEY=$(cat "$NODE_KEY_PATH")`

  

`NODE_ENODE=$(bootnode -nodekeyhex "$NODE_KEY" -writeaddress 2>/dev/null)`

  

`echo $NODE_ENODE`

  

- Place the enode entries of nodes in each node config.toml file in each node directory

  
  

- create config toml

`$workspace/rva-config-setup.sh $NUM_NODES`

  
  

`$workspace/rva-fetch-keys.sh $NUM_NODES`

  

`$workspace/rva-fetch-key2.sh $NUM_NODES`

  

- Now place the boot node enode and other validator nodes endode enteries in BootstrapNodes = [] and StaticNodes = [] in each node directory in directory `$HOME/RVA/bsc-chain/nodes`

- Run the bodes using :-

`docker-compose -f $workspace/docker-compose.yml up -d`