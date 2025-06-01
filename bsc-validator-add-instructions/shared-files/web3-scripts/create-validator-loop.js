const fs = require("fs");
const path = require("path");
const { Web3 } = require("web3");

// Initialize Web3
const RPC_URL = "http://127.0.0.1:8545";
const ABI_PATH = "/home/developer/rva-chain/files/abi/stakehub.abi";
const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000002002";
const ABI = JSON.parse(fs.readFileSync(ABI_PATH, "utf8"));
const web3 = new Web3(new Web3.providers.HttpProvider(RPC_URL));

const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

const minerPrivateKeys = {};
(async () => {
  for (let i = 1; i <= 5; i++) {
    const homeDir = process.env.HOME;
    const nodeDir = path.join(homeDir, "rva-chain", "nodes", `rva-node${i}`);
    const keystoreDir = path.join(nodeDir, "keystore");

    // Get keystore file
    const files = fs.readdirSync(keystoreDir);
    const keystoreFile = files.find((file) => file.startsWith("UTC"));
    if (!keystoreFile) {
      console.error(`❌ No keystore found in ${nodeDir}`);
      continue;
    }

    const keystorePath = path.join(keystoreDir, keystoreFile);
    const keystore = JSON.parse(fs.readFileSync(keystorePath, "utf8"));
    const password = `node${i}@rva`;

    let account;
    try {
      account = await web3.eth.accounts.decrypt(keystore, password);
      minerPrivateKeys[account.address] = account.privateKey;
      console.log(`🔧 Private key for rva-node${i}:`, account.privateKey);
      web3.eth.accounts.wallet.add(account);
      const PRIVATE_KEY = account.privateKey;
      const consensusAddress = account.address;
      console.log("🚀 ~ consensusAddress:", consensusAddress);

      let senderBalance = await web3.eth.getBalance(consensusAddress);

      //  let  receiverBalance = await web3.eth.getBalance(receiver);

      console.log(
        `Sender's balance: ${web3.utils.fromWei(senderBalance, "ether")} BNB`
      );

      const voteAddressPath = path.join(nodeDir, "voteaddress.txt");
      console.log("🚀 ~ voteAddressPath:", voteAddressPath);

      const blsProofPath = path.join(nodeDir, "bls_proof.txt");

      if (!fs.existsSync(voteAddressPath) || !fs.existsSync(blsProofPath)) {
        console.error(
          `❌ voteAddress.txt or blsProof.txt missing in ${nodeDir}`
        );
        continue;
      }

      const voteAddress = fs.readFileSync(voteAddressPath, "utf8").trim();
      console.log("🚀 ~ voteAddress:", voteAddress);
      const blsProof = fs.readFileSync(blsProofPath, "utf8").trim();
      console.log("🚀 ~ blsProof:", blsProof);

      const node_name = `Node${i}`;

      // Commission struct values
      const commission = {
        rate: 10, // 5% (use 10000 as 100%)
        maxRate: 100, // Max 50%
        maxChangeRate: 5, // Max increase of 10% per change
      };

      // Description struct values
      const description = {
        moniker: node_name, //it should be unique for every validator starting with capital letter
        identity: account.address,
        website: account.address,
        details: account.address,
      };
      const stakeAmount = web3.utils.toWei(
        (15000 + i * 1000).toString(),
        "ether"
      );

      // Prepare the transaction
      const tx = contract.methods.createValidator(
        consensusAddress,
        voteAddress,
        blsProof,
        commission,
        description
      );

      console.log("tx", tx);
      console.log();

      // Estimate gas
      const gas = await tx.estimateGas({
        from: account.address,
        value: stakeAmount,
      });
      console.log("gas", gas);

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
        gasPrice,
      };

      console.log("txData", txData);

      const signedTx = await web3.eth.accounts.signTransaction(
        txData,
        PRIVATE_KEY
      );

      // Send the signed transaction
      const receipt = await web3.eth.sendSignedTransaction(
        signedTx.rawTransaction
      );
      console.log("🚀 ~ receipt:", receipt);

      if (receipt.status !== 1n) {
        console.log(`❌ Transaction failed for rva-node${i}. Retrying...`);
        break;
      }
      console.log(
        `Validator Created rva-node${i}! Transaction Hash: ${receipt.transactionHash}`
      );
    } catch (err) {
      console.error(
        `❌ Failed to create validator for rva-node${i}:`,
        err.message
      );
      continue;
    }
  }
})();
