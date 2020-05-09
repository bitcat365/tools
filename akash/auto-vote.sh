#!/bin/bash

account_address=akash18dc7en6pdnyca3jf8ljp2ljn9lakcmpk2yrd45
validator_address=akashvaloper18dc7en6pdnyca3jf8ljp2ljn9lakcmpkqxdt97
account_password=1234567890
chain_id=centauri
account_save=1000000
program_path=/bin/akashctl

while true
do

    echo "########## withdraw-all-rewards ##########"
    echo $account_password | $program_path tx distribution withdraw-all-rewards --from bitcat --chain-id $chain_id -y

    sleep 5
    delegate_amount=`$program_path query account $account_address --chain-id $chain_id | grep amount | awk -F 'amount: "' '{print $2}' | awk -F '"' '{print $1}'`

    sleep 5
    delegate_amount_vote=`echo $delegate_amount - $account_save | bc`

    echo "########## start delegate ##########"
    sleep 5
    echo $account_password | $program_path tx staking delegate $validator_address $delegate_amount_vote"ubtsg" --chain-id $chain_id --from bitcat -y

    sleep 7200

done
