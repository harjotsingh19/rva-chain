const web3 = require('web3');
const RLP = require('rlp');

// Configure
const validators = [
  {
    consensusAddr: '0x9813a00A552f3fbA9F49fE799ADeE987600f3AF0',
    feeAddr: '0x9813a00A552f3fbA9F49fE799ADeE987600f3AF0',
    bscFeeAddr: '0x9813a00A552f3fbA9F49fE799ADeE987600f3AF0',
    votingPower: 0x0000000000000064,
  },
  {
    consensusAddr: '0xbBdDbbb7669DFA58338A0140dcd1d508bCEEd2Fd',
    feeAddr: '0xbBdDbbb7669DFA58338A0140dcd1d508bCEEd2Fd',
    bscFeeAddr: '0xbBdDbbb7669DFA58338A0140dcd1d508bCEEd2Fd',
    votingPower: 0x0000000000000064,
  },
//   {
//     consensusAddr: '0x1ECcdB61c352D3839930F62Bbe3057E7Cb23Dc87',
//     feeAddr: '0x1ECcdB61c352D3839930F62Bbe3057E7Cb23Dc87',
//     bscFeeAddr: '0x1ECcdB61c352D3839930F62Bbe3057E7Cb23Dc87',
//     votingPower: 0x0000000000000064,
//   },
];


const bLSPublicKeys = [
  // '0x978c1467f77d48e4768011cf23a8e16ff3f06fff6fabdb265de2dc0b123bb0547b62a2fe4009c15e8a512e3030b9d6c4',
  '0xb0f488568f9a2eb58ce478eb36efef6f680b0ccd8fe223e76a21242d3698315eb50c5ff215b3be9778a143d86f076d0f',
  '0x862f759a3772902837a739b3d8b107e03429e15c3b94a86e01629b180c8296ad5b0a3f0521b7f55b3c18ce10c8875e84'
  // '0x8f5df94eccdcdf19474a2ccf3069047b484b97c882dd5b8fe927d0ec811cdf1bc742b6b0ca680fa5143f0738ad8831df',
  // '0x87cc62c43dbd30e329b2bea28626b313f653a9b12604b653f08ebe96421c4a8ad0e738c301e1c0daf4c4edb72a79a25e',
];
;

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
