const { Web3 } = require("web3");

const web3 = new Web3("http://127.0.0.1:8545");

// new validator public address
const receiver = "0x272bC795259909eEEeB46B4A454fF752908C4E08"; // Replace with the receiver's account address

// Sender's private key
const senderPrivateKey =
  "0x6827e5055c2821253b82002b128e97beb8b8d9c3d159cfb5d6c580b7a53f1500";

let amountInBNB = "201000"; //

const amountInWei = web3.utils.toWei(amountInBNB, "ether"); // Convert BNB to Wei (BSC uses the same conversion as ETH to Wei)
console.log("amount in wei", amountInWei);

// Minimum required balance in BNB
const requiredBalanceInBNB = amountInBNB;
const requiredBalanceInWei = web3.utils.toWei(
  requiredBalanceInBNB.toString(),
  "ether"
); // Convert to Wei

// Function to send the transaction
async function sendTransaction() {
  try {
    const account = web3.eth.accounts.privateKeyToAccount(senderPrivateKey);
    const sender = account.address;
    console.log("Sender public address:", sender);

    // Check the balance of the sender and receiver before transaction
    let senderBalance = await web3.eth.getBalance(sender);
    let receiverBalance = await web3.eth.getBalance(receiver);

    console.log(
      `Sender's balance: ${web3.utils.fromWei(senderBalance, "ether")} BNB`
    );
    console.log(
      `Receiver's balance: ${web3.utils.fromWei(receiverBalance, "ether")} BNB`
    );

    // Check if sender has enough balance
    if (BigInt(senderBalance) < BigInt(requiredBalanceInWei)) {
      console.error(
        `Sender does not have enough balance. Required: ${requiredBalanceInBNB} BNB`
      );
      return; // Exit the function if balance is insufficient
    }
    console.log("sender has enough balalnce");

    // Get the transaction count (nonce) for the sender account
    const nonce = await web3.eth.getTransactionCount(sender, "latest");

    // Get the gas price for the network
    const gasPrice = await web3.eth.getGasPrice();

    // Construct the transaction object
    const tx = {
      from: sender,
      to: receiver,
      value: amountInWei, // Amount in Wei
      gas: 260000, // Standard gas for a simple ETH transfer
      gasPrice: gasPrice, // Gas price for the transaction
      nonce: nonce, // Transaction count (nonce)
      chainId: 2200, // Mainnet (change for other networks like Ropsten or local)
    };

    // Sign the transaction with the sender's private key
    const signedTx = await web3.eth.accounts.signTransaction(
      tx,
      senderPrivateKey
    );

    // Send the signed transaction to the Ethereum network
    const receipt = await web3.eth.sendSignedTransaction(
      signedTx.rawTransaction
    );
    console.log("🚀 ~ sendTransaction ~ receipt:", receipt)

    // Log the transaction receipt to confirm the transaction
    console.log("Transaction receipt:", receipt);

    senderBalance = await web3.eth.getBalance(sender);
    receiverBalance = await web3.eth.getBalance(receiver);

    console.log(
      `Sender's balance: ${web3.utils.fromWei(senderBalance, "ether")} BNB`
    );
    console.log(
      `Receiver's balance: ${web3.utils.fromWei(receiverBalance, "ether")} BNB`
    );
  } catch (error) {
    console.error("Error sending transaction:", error);
  }
}

// Execute the sendTransaction function
sendTransaction();
