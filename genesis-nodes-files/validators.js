const web3 = require('web3');
const RLP = require('rlp');

// Configure
const validators = [
    {
        consensusAddr: '0x2B2da2E6c980D925326B813e913b1D896e514C27',
        feeAddr: '0x2B2da2E6c980D925326B813e913b1D896e514C27',
        bscFeeAddr: '0x2B2da2E6c980D925326B813e913b1D896e514C27',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xCe9Ee94C94008a6e1d9c8586A813c9d949f0b446',
        feeAddr: '0xCe9Ee94C94008a6e1d9c8586A813c9d949f0b446',
        bscFeeAddr: '0xCe9Ee94C94008a6e1d9c8586A813c9d949f0b446',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xb6e8fcf3c309644c94662e89e006959f3810e897',
        feeAddr: '0xb6e8fcf3c309644c94662e89e006959f3810e897',
        bscFeeAddr: '0xb6e8fcf3c309644c94662e89e006959f3810e897',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0x75D227249aB3E2c13995489eD4e371a4Cd447A92',
        feeAddr: '0x75D227249aB3E2c13995489eD4e371a4Cd447A92',
        bscFeeAddr: '0x75D227249aB3E2c13995489eD4e371a4Cd447A92',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xac47287d043d51CF09bC03f50f267845fCb34e3C',
        feeAddr: '0xac47287d043d51CF09bC03f50f267845fCb34e3C',
        bscFeeAddr: '0xac47287d043d51CF09bC03f50f267845fCb34e3C',
        votingPower: 0x0000000000000064,
    }
];

const bLSPublicKeys = [
    '0x8f7aaa9ad93db3833ec79dab5dcbbf6b2010147a5ef510a621d8f1fcb5f9ac9b62fa4b58cbc3fd686bfa599762ba6b80',
    
    '0x85e48517c3e249eeee2cbe52d30fee2902be4e8ac9cd0c44361dc0eda84860f2f4ef62f473a25374b0884469e9a81248',
    
    '0xb20bb925bc56904e03128540233bbefa3006a352f2c605a50cdf754843596b343e4912170c344002ac29fc669febec7b',
    
    '0xb61929b5d08f38758b33b69ecf58c8f70aee48c459f30032972fbed5abfe839c94460aebad7b83057c47cc8eb131644b',
    
    '0xb2c0ae732bea01f48c6c4e889bdff87a5b4a9cd634f3892e414d52de7f54e11524191087588d27283aff7889b2e99851',
    
];

// ======== Do not edit below ========
function generateExtraData(validators) {
  let extraVanity = Buffer.alloc(32);
  let validatorsBytes = extraDataSerialize(validators);
  let extraSeal = Buffer.alloc(65);
  return Buffer.concat([extraVanity, validatorsBytes, extraSeal]);
}

function extraDataSerialize(validators) {
  let n = validators.length;
  let arr = [];
  for (let i = 0; i < n; i++) {
    let validator = validators[i];
    arr.push(Buffer.from(web3.utils.hexToBytes(validator.consensusAddr)));
  }
  return Buffer.concat(arr);
}

function validatorUpdateRlpEncode(validators, bLSPublicKeys) {
  let n = validators.length;
  let vals = [];
  for (let i = 0; i < n; i++) {
    vals.push([
      validators[i].consensusAddr,
      validators[i].bscFeeAddr,
      validators[i].feeAddr,
      validators[i].votingPower,
      bLSPublicKeys[i],
    ]);
  }
  let pkg = [0x00, vals];
  return web3.utils.bytesToHex(RLP.encode(pkg));
}

extraValidatorBytes = generateExtraData(validators);
validatorSetBytes = validatorUpdateRlpEncode(validators, bLSPublicKeys);

exports = module.exports = {
  extraValidatorBytes: extraValidatorBytes,
  validatorSetBytes: validatorSetBytes,
};
