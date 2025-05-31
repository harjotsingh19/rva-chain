
# SETUP NETWORK

## Clone the repo 
`cd $HOME`

`git clone https://github.com/harjotsingh19/rva-chain.git`

- Move to cloned directory
 
`cd $HOME/rva-chain/files` 

## Create N numbers of initial nodes
 - Set the value of NUM_NODES in `$HOME/rva-chain/files/bsc-nodes-bls.sh` file to set number of initial nodes with BLS proof and addresses you want to generate in network.
 
 - Set the workspace
 `workspace=$HOME/rva-chain/files`
 
 - set the initial number of validator nodes and their initial balance below 
 `NUM_NODES=5`
 `BALANCE=30000000000000000000000000`
 
- Now run the file to generate directory of each initial node

`$workspace/bsc-generate-nodes.sh $NUM_NODES $BALANCE`

- The above command will also generate init-holders.js and validator.js files that will replace init-holders.js and validator.js in bsc-genesis-contract repo scripts 


`sudo  rm  -rf  $workspace/nodes  $workspace/nodes-copy`


`cp  -r  $workspace/nodes-backup  $workspace/nodes`

## Change the number of INIT_NUM_OF_CABINET 
- Change INIT_NUM_OF_CABINET in $HOME/rva-chain/genesis-nodes-files/BSCValidatorSet.sol

## Generate genesis file using already cloned BSC genesis contract repo
This script will create bsc chain original bsc-genesis-contract repo to be edited , install foundry and install poetry , copy and replace  init-holders.js , validator.js ,generate.py,generate-genesis.js (you can change  chainid in it ),package.json (changed slashing,felonyetc configuration) and BSCValidatorSet.sol from $HOME/rva-chain/genesis-nodes-files to $HOME/rva-chain/bsc-genesis-contract/script and then generate new genesis.json and copy it to $HOME/rva-chain/files/genesis.json to be used to initialize nodes.

`$workspace/bsc-genesis-contract.sh`

## Now run the commands to setup boot node and other initial validator nodes and run the chain
- Setup workspace 

 
	`workspace=$HOME/RVA/bsc-chain`
	
	 `cd  $HOME/RVA/bsc-chain/files`

- Run the boot node with genesis.json generated using contract.sh file
	`./bsc-run-boot-node.sh  1`
	
- Setup same number of nodes again in constant NUM_NODES e.g. 5
	`NUM_NODES = 5` 

- Initialize the validator node with generated genesis.json 
`./bsc-run-nodes.sh  $NUM_NODES`

- Place the dummy config.toml file in each node directory
`./bsc-config-setup.sh  $NUM_NODES`

- Now place the boot node enode and other validator nodes endode enteries in BootstrapNodes = [] and StaticNodes = [] in each node directory in directory `$HOME/RVA/bsc-chain/nodes`
- Run the 