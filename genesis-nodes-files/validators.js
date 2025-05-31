const web3 = require('web3');
const RLP = require('rlp');

// Configure
const validators = [
    {
        consensusAddr: '0x312aD89dE1EAaa6BD18Cfa28970F4725458a9f60',
        feeAddr: '0x312aD89dE1EAaa6BD18Cfa28970F4725458a9f60',
        bscFeeAddr: '0x312aD89dE1EAaa6BD18Cfa28970F4725458a9f60',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0x80067B7391b756C4e220bde464dfc3DE8F238008',
        feeAddr: '0x80067B7391b756C4e220bde464dfc3DE8F238008',
        bscFeeAddr: '0x80067B7391b756C4e220bde464dfc3DE8F238008',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xa87B3D391e56D802D9Ab91B047cd2F02A42b1796',
        feeAddr: '0xa87B3D391e56D802D9Ab91B047cd2F02A42b1796',
        bscFeeAddr: '0xa87B3D391e56D802D9Ab91B047cd2F02A42b1796',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0x258a32bcbc04c13939e16d33fff2e0Ac7236b004',
        feeAddr: '0x258a32bcbc04c13939e16d33fff2e0Ac7236b004',
        bscFeeAddr: '0x258a32bcbc04c13939e16d33fff2e0Ac7236b004',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xb2d2823e9f4A7281d9913d6205e67008D4DC0ec6',
        feeAddr: '0xb2d2823e9f4A7281d9913d6205e67008D4DC0ec6',
        bscFeeAddr: '0xb2d2823e9f4A7281d9913d6205e67008D4DC0ec6',
        votingPower: 0x0000000000000064,
    }
];

const bLSPublicKeys = [
    '0x80c049cfb136dc523817e6a456ba9519b6d0c2b26b54c14b3b8d9ed75f22eeba5999c837a7319ca3be6dec1a56e7fc69',
    
    '0xb2416f74b2dc59c606c8da0e6fc21f4455726fe690a1b73f2a1850678bdc2e663d4c3e3bfe3bcaaaecd250fb4904a63b',
    
    '0x893b460e43583eb42259ac6e05269d232c5ac9ef89c5a5e51f585b8e57eea6e2badc8ed9b64cea403727b827b08b9dbc',
    
    '0x8861a0247f7a1ab29f46a5ad0afafdc92875c29bfac304a974f10091ac3f677c2e69f42f2815ad546ebee704e7b78b0d',
    
    '0xa5a7b0553fc3df0fb0b9c315ffd7da17acdd9fcb87fd0129bf777c5964d0c7c71f48ba04e202b3d9126d0e61d7e868df',
    
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
