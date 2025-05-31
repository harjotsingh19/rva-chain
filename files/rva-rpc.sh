#!/usr/bin/env bash

set -x

DATA_DIR=/root/rva-rpc

ls $DATA_DIR/keystore

VERBOSE=3

# account_cnt=$(ls ${DATA_DIR}/keystore | wc -l)

# echo "account_cnt $account_cnt"
# i=1
# unlock_sequences="0"
# while [ "$i" -lt ${account_cnt} ]; do
#     unlock_sequences="${unlock_sequences},${i}"
#     i=$(( i + 1 ))
# done 


# echo "unlock_sequences $unlock_sequences"

# $HOME/geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} \
#     --verbosity ${VERBOSE} --syncmode "full"\
#     --rpc.allow-unprotected-txs --history.transactions 15768000 \
#     -unlock ${unlock_sequences} --password /dev/null  >${DATA_DIR}/bscnode-rpc.log


$HOME/geth --config ${DATA_DIR}/config.toml --datadir ${DATA_DIR} \
    --verbosity ${VERBOSE} --syncmode "full"\
    --rpc.allow-unprotected-txs --history.transactions 15768000 \
    --password /dev/null  >${DATA_DIR}/bscnode-rpc.log    


set +x