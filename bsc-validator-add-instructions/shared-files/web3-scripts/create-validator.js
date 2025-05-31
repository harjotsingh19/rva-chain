const { Web3 } = require("web3");
const fs = require("fs");
const crypto = require("crypto");
const { ethers } = require("ethers"); 

// Initialize Web3 provider
const RPC_URL = "http://127.0.0.1:8545"; // Your RPC URL
const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000002002"; // Your contract address
const ABI_PATH = "./abi/stakehub.abi"; // Update with correct ABI path

// Load contract ABI
const ABI = JSON.parse(fs.readFileSync(ABI_PATH, "utf-8"));

const web3 = new Web3(new Web3.providers.HttpProvider(RPC_URL));

// PRIVATE KEY OF OLD VALIDATOR TO BE ADDED.
const PRIVATE_KEY = "0xb886a23d90b126a94f8c532ecc873996ab5877287fba1c897d70be360c63c1b5";

const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);

const voteAddress = "0xb5d569529d9e234484ce940ae508623344e74fa59c4e37da1811fc243a596f9e694aa05bddf554268e3aa2707efdc9b5"; // 

//public address of old validator
const consensusAddress = account.address;
// const consensusAddress="0xC0BD417c4E3c6F9443b3B4D74ED29aA0eE9fEBD2"

console.log('Generated Consensus Address:', consensusAddress);


// BLS PROOF GENERATED DURING CREATION OF OLD VALIDATOR BLS ACCOUNT.
const blsProof = "0x88c484306deabf446a0b1db1be6b5457070df8c3e9082741e6c45ef2db1b1b0e3bb40d58f236ee44e6bb922a66b4b3ec170506ffcca6f11d0cf60917bc45d414f61dbc95470dfec434d11cf0df1633cabcf88912387331f8aaea0a78499edc91" 

const node_name="Node1"





console.log("Account Address:", account.address);




// Initialize contract
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

async function createValidator() {

    // Commission struct values
    const commission = {
        rate: 10,  // 5% (use 10000 as 100%)
        maxRate: 100,  // Max 50%
        maxChangeRate: 5 // Max increase of 10% per change
    };

    // Description struct values
    const description = {
        moniker: node_name,   //it should be unique for every validator starting with capital letter
        identity: account.address,
        website: account.address,
        details: account.address
    };


    const stakeAmount = web3.utils.toWei("15000", "ether"); 
    
    
    try {
        // Prepare the transaction
        const tx = contract.methods.createValidator(
            consensusAddress,
            voteAddress,
            blsProof,
            commission,
            description
        );
        
        console.log("tx",tx);
        console.log();
        

        // Estimate gas
        const gas = await tx.estimateGas({ from: account.address, value: stakeAmount });
        console.log("gas",gas);

        // return gas
        
        
        const gasPrice = await web3.eth.getGasPrice();

        // Create the transaction data
        const txData = {
            from: account.address,
            to: CONTRACT_ADDRESS,
            data: tx.encodeABI(),
            value: stakeAmount,
            // value: delegation + toLock,
            gas,
            gasPrice
        };
       

        console.log("txData",txData);

        const signedTx = await web3.eth.accounts.signTransaction(txData, PRIVATE_KEY);

        // Send the signed transaction
        const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

        console.log("Validator Created! Transaction Hash:", receipt.transactionHash);
        console.log("Validator Created! Transaction Hash:", receipt);
    } catch (error) {
        console.error(" Error creating validator:", error);
    }
}

createValidator();



