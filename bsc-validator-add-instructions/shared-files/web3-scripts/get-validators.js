const { Web3 } = require("web3");
const fs = require("fs");
const { ethers } = require("ethers");  // Import ethers for working with Ethereum addresses

// Initialize Web3 provider
const RPC_URL = "http://127.0.0.1:8546"; // Your RPC URL

console.log("rpc",RPC_URL);


const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000002002"; // Your contract address
const ABI_PATH = "/home/harjot/Desktop/RVA/bsc-chain/genesis/abi/stakehub.abi"; // Update with correct ABI path



// Initialize Web3
const web3 = new Web3(new Web3.providers.HttpProvider(RPC_URL));

const stakeHubContractABI = require("./abi/stakeHub.json")
const stakeHubContractAddress = "0x0000000000000000000000000000000000002002"

const stakeHubContract = new web3.eth.Contract(stakeHubContractABI, stakeHubContractAddress);



// Example values for offset and limit
const offset = 0;
const limit = 20;


async function getValidators() {
    try {
        // Call the getValidators function from the contract
        const validators = await stakeHubContract.methods.getValidators(offset, limit).call();
        console.log("validators",validators);

        const getValidatorElectionInfo = await stakeHubContract.methods.getValidatorElectionInfo(offset, limit).call();
        console.log("🚀 ~ callValidatorSetContract ~ getValidatorElectionInfo:", getValidatorElectionInfo) 

    } catch (error) {
        console.error("Error calling getValidators:", error);
    }
}

getValidators();
