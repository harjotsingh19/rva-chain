const Web3 = require('web3').default;

// Connect to BSC Testnet
// const rpcUrl = "https://data-seed-prebsc-1-s1.binance.org:8545/"; // BSC RPC URL
// const rpcUrl = "https://bsc-dataseed.binanace.org/"; // BSC RPC URL
// const rpcUrl = "https://rpc.ankr.com/bsc/"
const rpcUrl = "http://localhost:8546/"

// const rpcUrl="http://13.42.115.80:8541"
const web3 = new Web3(rpcUrl);
// console.log("🚀 ~ web3:", web3)

// ABI's for the contract
const systemRewardContractABI = require("./abi/SystemRewardABI.json")
const stakeHubContractABI = require("./abi/StakeHubABI.json")
const validatorSetContractABI = require("./abi/ValidatorSetABI.json")
const slashIndicatorContractABI = require("./abi/SlashIndicatorABI.json")


// Contract address (Replace with actual address)
// const systemRewardContractAddress = "0x0000000000000000000000000000000000001002"
const stakeHubContractAddress = "0x0000000000000000000000000000000000002001"
const validatorSetContractAddress = "0x0000000000000000000000000000000000001000"
const slashIndicatorContractAddress = "0x0000000000000000000000000000000000001001"

// Initialize the staking contract
const stakeHubContract = new web3.eth.Contract(stakeHubContractABI, stakeHubContractAddress);
const validatorSetContract = new web3.eth.Contract(validatorSetContractABI, validatorSetContractAddress);
const slashIndicatorContract = new web3.eth.Contract(slashIndicatorContractABI, slashIndicatorContractAddress);



async function callValidatorSetContract() {
    try {

        const numOfCabinets = await validatorSetContract.methods.INIT_NUM_OF_CABINETS().call();
        console.log("🚀 ~ callValidatorSetContract ~ numOfCabinets:", numOfCabinets)
        
        const getValidators = await validatorSetContract.methods.getValidators().call();
        console.log("🚀 ~ callValidatorSetContract ~ getValidators:", getValidators) // returns all validators, 45

    
        const getMiningValidators = await validatorSetContract.methods.getMiningValidators().call();
        console.log("🚀 ~ getMiningValidators ~ getMiningValidators:", getMiningValidators) // returns 21 validators set


    } catch (error) {
        console.error("Error: ", error);
    }
}


callValidatorSetContract();

