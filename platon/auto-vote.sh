#!/bin/bash

address=0xe3a0b6cb189584b5fd056b5eddbf68ecf2293e12
MTOOLDIR=/home/ubuntu/mtool-client-0.8.0.0
vote_threshold=200
account_balance_save=1

while true
do

    account_validator_balance=`mtool-client account balance -a $address  --config $MTOOLDIR/validator/validator_config.json | grep LAT | awk -F 'LAT:' '{print$2}' | awk -F '.' '{print$1}'`
    echo "########### validator avaible balance is" $account_validator_balance
    vote_validator_balance=`expr $account_validator_balance - $account_balance_save`
    echo "########### validator account save is" $account_balance_save , "execute vdalidator vote token is" $vote_validator_balance


    if [ $vote_validator_balance -gt $vote_threshold ]
            # execute validator and group
            then
                echo "########### Start increasestaking ###########"

                echo AAaa12345 | mtool-client increasestaking --amount $vote_validator_balance --keystore $MTOOLDIR/keystore/staking.json --config $MTOOLDIR/validator/validator_config.json

                echo "########### completed increasestaking ###########"
                sleep 5

            else
                echo "########### NO BALANCE CAN VOTE ###########"

            fi
    sleep 1800
done
