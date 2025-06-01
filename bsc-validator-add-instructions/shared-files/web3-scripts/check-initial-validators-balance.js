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

      console.log();
      
      //  let  receiverBalance = await web3.eth.getBalance(receiver);

      console.log(
        `Sender's balance: ${web3.utils.fromWei(senderBalance, "ether")} BNB`
      );
      console.log();
      

      const voteAddressPath = path.join(nodeDir, "voteaddress.txt");

      const blsProofPath = path.join(nodeDir, "bls_proof.txt");

      if (!fs.existsSync(voteAddressPath) || !fs.existsSync(blsProofPath)) {
        console.error(
          `❌ voteAddress.txt or blsProof.txt missing in ${nodeDir}`
        );
        continue;
      }

      // const voteAddress = fs.readFileSync(voteAddressPath, "utf8").trim();
      // console.log("🚀 ~ voteAddress:", voteAddress);
      // const blsProof = fs.readFileSync(blsProofPath, "utf8").trim();
      // console.log("🚀 ~ blsProof:", blsProof);

    } catch (err) {
      console.error(
        `❌ Failed to fetch validator balance for rva-node${i}:`,
        err.message
      );
      continue;
    }
  }
})();
