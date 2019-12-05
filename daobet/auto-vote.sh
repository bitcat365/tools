#!/bin/bash

priv_key=
wallet_name=
daobet_cli_path=
vote_account=
validator_accout=
#save balance 10 BET

while true
do
        echo "sleep...wating after 86401sec"
        sleep 86401

        #unlock wallet
        echo $priv_key | $daobet_cli_path wallet unlock --name $wallet_name

        #make claim
        $daobet_cli_path system claimrewards $account
        echo "completed claim"

        balance=`$daobet_cli_path get currency balance eosio.token $account BET`
        echo current balance is $balance

        final_balance=`echo $balance | awk -F ' ' '{print ($1-10)}'`
        echo After save 10Bet balance is $final_balance

        $daobet_cli_path system delegatebw $account $account "0 BET" "0 BET" "$final_balance BET"
        echo "completed delegatebw"

        $daobet_cli_path system voteproducer prods $account $validator_accout
        echo "completed voteproducer"

done
