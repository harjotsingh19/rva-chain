const { Web3 } = require("web3");
const fs = require("fs");
const crypto = require("crypto");
const { ethers } = require("ethers"); 

// Initialize Web3 provider
const RPC_URL = "http://127.0.0.1:8545"; // Your RPC URL
const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000002002"; // Your contract address
const ABI_PATH = "/home/developer/rva-chain/files/abi/stakehub.abi"; // Update with correct ABI path

// Load contract ABI
const ABI = JSON.parse(fs.readFileSync(ABI_PATH, "utf-8"));

const web3 = new Web3(new Web3.providers.HttpProvider(RPC_URL));

// PRIVATE KEY OF OLD VALIDATOR TO BE ADDED.
const PRIVATE_KEY = "0x0424c55826f64c547c24fd4f5ac33009ee6760afbef7f7b88e80cb603865c434";

const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);

const voteAddress = "0xb5a31129db8629e89b519fe41e363669f09648964633dea7b3d2b0439076650e71cde860e5c3be686e8e287a29658ac3"; // 

//public address of old validator
const consensusAddress = account.address;
// const consensusAddress="0xC0BD417c4E3c6F9443b3B4D74ED29aA0eE9fEBD2"

console.log('Generated Consensus Address:', consensusAddress);


// BLS PROOF GENERATED DURING CREATION OF OLD VALIDATOR BLS ACCOUNT.
const blsProof = "0xa0e7e2dc45111d03fdc77610000f548faa66acb1d15d259f3feb2c71964615b5bd3e8ac8d754fc22b45290ae125b8e0119de241f9b8bc37d595fab57d055b7753aaa740c344321a3c46b4b7f304255a7a20c0669de6fc8c62e4c3653014cfae7" 

const node_name="NewNode1"





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


    const stakeAmount = web3.utils.toWei("25000", "ether"); 
    
    
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
        console.log("Validator Created! Transaction receipt:", receipt);
    } catch (error) {
        console.error(" Error creating validator:", error);
    }
}

createValidator();



