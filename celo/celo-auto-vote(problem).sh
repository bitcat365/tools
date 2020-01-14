#!/bin/bash

validator_address=cbebe96dd4811243e23b1f7b43d7c3266c59af2f
group_address=93c110dc9812dc075c1541b2c5d1030b2ad6c293
account_valadator_save=1000000000000000000
account_group_save=1000000000000000000

while true
do
        account_validator_balance=`celocli account:balance $validator_address | grep goldBalance | awk -F 'goldBalance: ' '{print $2}'`
        echo "########### validator avaible balance is" $account_validator_balance
        vote_validator_balance=`echo $account_validator_balance - $account_valadator_save | bc`
        echo "########### validator account save is" $account_valadator_save , "execute vdalidator vote token is" $vote_validator_balance

        account_group_balance=`celocli account:balance $group_address | grep goldBalance | awk -F 'goldBalance: ' '{print $2}'`
        echo "########### group avaible balance is" $account_group_balance
        vote_group_balance=`echo $account_group_balance - $account_group_save | bc`
        echo "########### group account save is" $vote_group_balance , "execute group vote token is" $vote_group_balance

        if [ $vote_validator_balance -gt $account_valadator_save ] && [ $vote_group_balance -gt $account_group_save ]
        # execute validator and group
        then
            echo "########### Start lock validator and group ###########"
            celocli lockedgold:lock --from $validator_address --value $vote_validator_balance
            sleep 5
            celocli lockedgold:lock --from $group_address --value $vote_group_balance

            echo "########### Start vote validator and group ###########"
            celocli election:vote --from $validator_address --for $group_address --value $vote_validator_balance
            sleep 5
            celocli election:vote --from $group_address --for $group_address --value $vote_group_balance

            echo "########### Start acitve validator and group ###########"
            sleep 5
            celocli election:activate --from $validator_address --wait && celocli election:activate --from $group_address --wait
        else
            if [ $vote_validator_balance -gt $vote_validator_balance ];
            # execute validator
            then
                echo " ########### Start lock validator ###########"
                sleep 5
                celocli lockedgold:lock --from $validator_address --value $vote_validator_balance

                echo " ########### Start vote validator ###########"
                sleep 5
                celocli election:vote --from $validator_address --for $group_address --value $vote_validator_balance

                echo " ########### Start acitve validator ###########"
                sleep 5
                celocli election:activate --from $validator_address --wait
            elif [ $vote_group_balance -gt account_group_save ];
            # execute group
            then
                
                echo "########### Start lock group ###########"
                sleep 5
                celocli lockedgold:lock --from $group_address --value $vote_group_balance

                echo "########### Start vote group ###########"
                sleep 5
                celocli election:vote --from $group_address --for $group_address --value $vote_group_balance

                echo "########### Start acitve group ###########"
                sleep 5
                celocli election:activate --from $group_address --wait
            else
                echo "########### NO BALANCE CAN VOTE ###########"
            fi    
        fi
done
