#!/bin/bash

account_address=bitsong1a2vlxncaesht7f3exj2g8yamfxwzafw772vdx5
validator_address=bitsongvaloper1a2vlxncaesht7f3exj2g8yamfxwzafw7lwsykf
account_password=1234567890

while true 
do

    echo "########## withdraw-all-rewards ##########"
    echo $account_password | /mnt/node/bitsong/bitsongcli tx distribution withdraw-all-rewards --chain-id bitsong-testnet-3 --from bitcat -y

    sleep 5
    delegate_amount=`/mnt/node/bitsong/bitsongcli query account $account_address --chain-id bitsong-testnet-3 | grep amount | awk -F 'amount: "' '{print $2}' | awk -F '"' '{print $1}'`
    
    sleep 5
    delegate_amount_vote=`echo $delegate_amount - 1000000 | bc`

    echo "########## start delegate ##########"
    sleep 5
    echo $account_password | /mnt/node/bitsong/bitsongcli tx staking delegate $validator_address $delegate_amount_vote"ubtsg" --chain-id bitsong-testnet-3 --from bitcat -y

    sleep 7200

done
