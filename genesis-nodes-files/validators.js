const web3 = require('web3');
const RLP = require('rlp');

// Configure
const validators = [
    {
        consensusAddr: '0x06BF7e181E645ad8E1736F95399e692f112F9f97',
        feeAddr: '0x06BF7e181E645ad8E1736F95399e692f112F9f97',
        bscFeeAddr: '0x06BF7e181E645ad8E1736F95399e692f112F9f97',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0x897CD29bf328349AEf7caC590bC8B71A06B2b038',
        feeAddr: '0x897CD29bf328349AEf7caC590bC8B71A06B2b038',
        bscFeeAddr: '0x897CD29bf328349AEf7caC590bC8B71A06B2b038',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0x778996ed4282DF571F639dF0dAcc76377d02643d',
        feeAddr: '0x778996ed4282DF571F639dF0dAcc76377d02643d',
        bscFeeAddr: '0x778996ed4282DF571F639dF0dAcc76377d02643d',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xD8AF89BE2864d1E424F670dF5243F863aDB78672',
        feeAddr: '0xD8AF89BE2864d1E424F670dF5243F863aDB78672',
        bscFeeAddr: '0xD8AF89BE2864d1E424F670dF5243F863aDB78672',
        votingPower: 0x0000000000000064,
    },
    {
        consensusAddr: '0xD00C37B8c20c370391133A5DbDE9ed4c6562A20a',
        feeAddr: '0xD00C37B8c20c370391133A5DbDE9ed4c6562A20a',
        bscFeeAddr: '0xD00C37B8c20c370391133A5DbDE9ed4c6562A20a',
        votingPower: 0x0000000000000064,
    }
];

const bLSPublicKeys = [
    '0xa6f581b6db3341da22bb4d8abbb76a015443ebb8b7e97ebc0b127609e8986154a6678436b7d3fe3afa4f9c87691b9573',
    
    '0x90e0587b23ef34801b9f921954c49a6cba982725bb4c3396397191dd898d139ac682035e19f62f17b05ec040ce8fce35',
    
    '0x8679d0046e59e4b5f9fdb43c2338a992930921cb79219dcd1f162236a6365578d11eba93ec30c74f319c824e3650de35',
    
    '0xadd7dfcb98decdad01cd02d2473325e9bcf1b2399b550db811f4fda8368aa6adc02247129ea7493ce87a14c91f2e5d88',
    
    '0x894f15e7d545fc7d6e6c76b351284d3fa08521defe96bb1528dfc3c0ba2feb30c37caf4dd8a30326681e935a22df6b86',
    
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
