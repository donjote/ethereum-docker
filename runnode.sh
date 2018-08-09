#!/bin/bash
IMGNAME="ethereum/client-go:v1.8.12"
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
DETACH_FLAG=${DETACH_FLAG:-"-d"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-"${HOME}/Ethereum"}
DATA_HASH=${DATA_HASH:-"${HOME}/Ethereum/.ethash"}
echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
RPC_PORTMAP=
RPC_ARG=

if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcport 8545 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"'
    RPC_PORTMAP="-p $RPC_PORT:8545"
fi
BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}
if [ ! -f $DATA_ROOT/genesis.json ]; then
    echo "No genesis.json file found, running 'genesis.sh'..."
    ./genesis.sh
    echo "...done!"
fi
if [ ! -d $DATA_ROOT/.ether-$NODE_NAME/keystore ]; then
    echo "$DATA_ROOT/.ether-$NODE_NAME/keystore not found, running 'geth init'..."
    docker run --rm \
        -v $DATA_ROOT/.ether-$NODE_NAME:/root/.ethereum \
        -v $DATA_ROOT/genesis.json:/opt/genesis.json \
        $IMGNAME init /opt/genesis.json
    echo "...done!"
fi
echo "Running new container $CONTAINER_NAME..."
docker run $DETACH_FLAG --name $CONTAINER_NAME \
    --network ethereum \
    -v $DATA_ROOT/.ether-$NODE_NAME:/root/.ethereum \
    -v $DATA_HASH:/root/.ethash \
    -v $DATA_ROOT/genesis.json:/opt/genesis.json \
    $RPC_PORTMAP \
    $IMGNAME --bootnodes=$BOOTNODE_URL $RPC_ARG --cache=512 --verbosity=4 --maxpeers=3 ${@:2}