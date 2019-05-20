#!/bin/bash

echo "Fetching the Zcash zkSNARK parameters"
./bin/zcutil/fetch-params.sh

if [ ! -e "$HOME/.komodo/komodo.conf" ]; then
    echo \
        "...Creating komodo.conf"
    echo \
"rpcuser=${rpcuser:-`pwgen -s 32 1`}
rpcpassword=${rpcpassword:-`pwgen -s 64 1`}
txindex=1
bind=${listenip:-127.0.0.1}
rpcbind=${listenip:-127.0.0.1}" | tee ${HOME}/.komodo/komodo.conf
    cat $HOME/.komodo/komodo.conf
fi
