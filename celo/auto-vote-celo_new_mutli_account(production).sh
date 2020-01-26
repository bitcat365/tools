#!/bin/bash
#for celocli version 0.32

account_validator_addr=cbebe96dd4811243e23b1f7b43d7c3266c59af2f
account_validator_addr2=3f92afea073cb35a03699f2989a3af3f24c8b517
account_group_addr=93c110dc9812dc075c1541b2c5d1030b2ad6c293
account_group_addr2=0x5eEE762a960560Cb6a625F280e53F92d93EC9b78
account_goldBalance_hold=2000000000000000000
account_goldBalance_hold_token=2

while true
do

        echo "************* start time" + `date`
        echo "@@@@@@@@@@@@ calcuator valadador1 address balance @@@@@@@@@@@@"
        account_validator_dollarBalance_check=`celocli account:balance $account_validator_addr | grep dollarBalance | awk -F 'dollarBalance: ' '{print $2}'`
        account_validator_dollarBalance_check_do=`printf "%b" $account_validator_dollarBalance_check`
        account_validator_dollarBalance=`echo ${account_validator_dollarBalance_check_do%.*}`

        account_vdalidator_dollarBalance_ex_for_pre=`echo "$account_validator_dollarBalance * 0.9" | bc`
        account_vdalidator_dollarBalance_ex_for=`echo ${account_vdalidator_dollarBalance_ex_for_pre%.*}`

        echo "########### start exchange for valadator1 ###########"
        celocli exchange:dollars --value $account_validator_dollarBalance --from $account_validator_addr --for $account_vdalidator_dollarBalance_ex_for

        account_validator_goldBalance=`celocli account:balance $account_validator_addr | grep goldBalance | awk -F 'goldBalance: ' '{print $2}'`
        account_validator_goldBalance_vo=`printf "%b" $account_validator_goldBalance`
        account_validator_goldBalance_vo_do=`echo ${account_validator_goldBalance_vo%.*}`
        account_validator_goldBalance_vote=`echo $account_validator_goldBalance_vo_do - $account_goldBalance_hold | bc`


        echo "@@@@@@@@@@@@ calcuator valadador address2 balance @@@@@@@@@@@@"
        account_validator_dollarBalance_check2=`celocli account:balance $account_validator_addr2 | grep dollarBalance | awk -F 'dollarBalance: ' '{print $2}'`
        account_validator_dollarBalance_check_do2=`printf "%b" $account_validator_dollarBalance_check2`
        account_validator_dollarBalance2=`echo ${account_validator_dollarBalance_check_do2%.*}`

        account_vdalidator_dollarBalance_ex_for_pre2=`echo "$account_validator_dollarBalance2 * 0.9" | bc`
        account_vdalidator_dollarBalance_ex_for2=`echo ${account_vdalidator_dollarBalance_ex_for_pre2%.*}`

        echo "########### start exchange for valadator2 ###########"
        celocli exchange:dollars --value $account_validator_dollarBalance2 --from $account_validator_addr2 --for $account_vdalidator_dollarBalance_ex_for2

        account_validator_goldBalance2=`celocli account:balance $account_validator_addr2 | grep goldBalance | awk -F 'goldBalance: ' '{print $2}'`
        account_validator_goldBalance_vo2=`printf "%b" $account_validator_goldBalance2`
        account_validator_goldBalance_vo_do2=`echo ${account_validator_goldBalance_vo2%.*}`
        account_validator_goldBalance_vote2=`echo $account_validator_goldBalance_vo_do2 - $account_goldBalance_hold | bc`


        echo "@@@@@@@@@@@@ calcuator group address balance @@@@@@@@@@@@"
        account_group_dollarBalance_check=`celocli account:balance $account_group_addr | grep dollarBalance | awk -F 'dollarBalance: ' '{print $2}'`
        account_group_dollarBalance_check_do=`printf "%b" $account_group_dollarBalance_check`
        account_group_dollarBalance=`echo ${account_group_dollarBalance_check_do%.*}`

        account_group_dollarBalance_ex_for_pre=`echo "$account_group_dollarBalance * 0.9" | bc`
        account_group_dollarBalance_ex_for=`echo ${account_group_dollarBalance_ex_for_pre%.*}`

        echo "########### start exchange for group ###########"
        celocli exchange:dollars --value $account_group_dollarBalance --from $account_group_addr --for $account_group_dollarBalance_ex_for

        account_group_goldBalance=`celocli account:balance $account_group_addr | grep goldBalance | awk -F 'goldBalance: ' '{print $2}'`
        account_group_goldBalance_vo=`printf "%b" $account_group_goldBalance`
        account_group_goldBalance_vo_do=`echo ${account_group_goldBalance_vo%.*}`
        account_group_goldBalance_vote=`echo $account_group_goldBalance_vo_do - $account_goldBalance_hold | bc`


        echo "@@@@@@@@@@@@ Start lock validator1&2 and group @@@@@@@@@@@@"
        celocli lockedgold:lock --from $account_validator_addr --value $account_validator_goldBalance_vote
        celocli lockedgold:lock --from $account_validator_addr2 --value $account_validator_goldBalance_vote2
        celocli lockedgold:lock --from $account_group_addr --value $account_group_goldBalance_vote

        echo "########### Start vote validator1&2  and group ###########"
        celocli election:vote --from $account_validator_addr --for $account_group_addr --value $account_validator_goldBalance_vote
        celocli election:vote --from $account_validator_addr2 --for $account_group_addr2 --value $account_validator_goldBalance_vote2
        celocli election:vote --from $account_group_addr --for $account_group_addr --value $account_group_goldBalance_vote

        echo "########### Start acitve validator1&2  and group ###########"
        celocli election:activate --from $account_validator_addr --wait && celocli election:activate --from $account_validator_addr2 --wait && celocli election:activate --from $account_group_addr --wait

        sleep 3600
        #every epoch will take 720(length) * 5s(blocktimes)
done
