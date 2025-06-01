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

(async () => {
  const homeDir = process.env.HOME;
  const nodeDir = path.join(
    homeDir,
    "rva-chain",
    "new-validator",
    `rva-new-node1`
  );
  const keystoreDir = path.join(nodeDir, "keystore");

  // Get keystore file
  const files = fs.readdirSync(keystoreDir);
  const keystoreFile = files.find((file) => file.startsWith("UTC"));
  if (!keystoreFile) {
    console.error(`❌ No keystore found in ${nodeDir}`);
    return;
  }

  const keystorePath = path.join(keystoreDir, keystoreFile);
  const keystore = JSON.parse(fs.readFileSync(keystorePath, "utf8"));
  const password = ``;

  let account;
  try {
    account = await web3.eth.accounts.decrypt(keystore, password);
    web3.eth.accounts.wallet.add(account);
    const PRIVATE_KEY = account.privateKey;
    console.log();

    console.log("🚀 ~ PRIVATE_KEY:", PRIVATE_KEY);

    console.log();
  } catch (err) {
    console.error(
      `❌ Failed to fetch validator's private key node:`,
      err.message
    );
    return;
  }
})();
