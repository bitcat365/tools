#!/bin/bash

KEY=""  #kvcli keys list or kava...
PASSPHRASE=""  #key password
THRESHOLD=10000000  #default 100kava. unit:ukava  1kava=1000000ukava
START_TIME=30 #default 30s. recheck time

PROGRAM_PATH=""  #e.g. /usr/bin/kvcli

DELEGATE_ADDRESS=""  #kava...
VALIDATOR_ADDRESS="" #kavavaloper...

CHAIN_ID="kava-testnet-3000"
GAS="auto"
GAS_ADJUSTMENT=1.5

##############################################

while true

        echo $START_TIME "times start"
        sleep $START_TIME
do
        delegate_rewards=`$PROGRAM_PATH query distribution rewards $DELEGATE_ADDRESS $VALIDATOR_ADDRESS  --chain-id $CHAIN_ID --output json | jq -r '.[0] | .amount'`
        commission_rewards=`$PROGRAM_PATH query distribution commission $VALIDATOR_ADDRESS --chain-id $CHAIN_ID --output json | jq -r '.[0] | .amount'`

        delegate_rewards_int=`echo $delegate_rewards | awk '{print int($0)}'`
        commission_rewards_int=`echo $commission_rewards | awk '{print int($0)}'`
        total_rewards=`expr $delegate_rewards_int + $commission_rewards_int`

        echo "Delegate Rewards:" $delegate_rewards_int 
        echo "Commission Reards:" $commission_rewards_int 
        echo "Total Reward:" $total_rewards

        if [ $total_rewards -gt $THRESHOLD ]
                then
                echo $PASSPHRASE | $PROGRAM_PATH tx distribution withdraw-all-rewards --chain-id $CHAIN_ID --from $KEY -y

                sleep 20
                echo $PASSPHRASE | $PROGRAM_PATH tx distribution withdraw-rewards $VALIDATOR_ADDRESS --chain-id $CHAIN_ID --from $KEY --commission -y

                sleep 20 #Start delegate
                echo $PASSPHRASE | $PROGRAM_PATH tx staking delegate $VALIDATOR_ADDRESS ${THRESHOLD}ukava --chain-id $CHAIN_ID --from $KEY   --gas-adjustment $GAS_ADJUSTMENT --gas $GAS -y
        else
                echo "Not sufficient funds"
        fi
done

