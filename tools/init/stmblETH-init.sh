#!/bin/bash
wget -q freeby.mesanet.com/95tinit.tgz
tar -xzf 95tinit.tgz

export INTERFACE='elbp16'
export IPADDR='192.168.1.121'
export PROTOCOL='direct'

./95tinit/setname stmblETH
./95tinit/setmac 0073746D626C

./95tinit/ereset