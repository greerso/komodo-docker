#!/bin/bash
set -e
# Check for and fetch zcash zkSNARK parameters
echo "Fetching the Zcash zkSNARK parameters"
./bin/fetch-params.sh

# Check for and create komodo.conf
if [ ! -e "${HOME}/.komodo/komodo.conf" ]; then
    echo "...Creating komodo.conf"
    echo "rpcuser=${RPC_USER:-`pwgen -s 32 1`}
rpcpassword=${RPC_PASSWORD:-`pwgen -s 64 1`}
txindex=1
server=1
daemon=0
rpcworkqueue=256
rpcbind=127.0.0.1" | tee ${HOME}/.komodo/komodo.conf
else
    echo "existing ${HOME}/.komodo/komodo.conf found"
    cat ${HOME}/.komodo/komodo.conf
fi
chmod 600 ~/.komodo/komodo.conf
# Check for and download blockchain bootstrap
if [ ! -d "${HOME}/.komodo/blocks" ]; then
    echo "Downloading KMD Blockchain Bootstrap"
    curl -fsL https://bootstrap.dexstats.info/KMD-bootstrap.tar.gz | tar xvz -C ${HOME}/.komodo/
fi

exec "$@"