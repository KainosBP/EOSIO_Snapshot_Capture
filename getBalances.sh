#!/bin/bash
#
# Script by J.T. Buice - KainosBP.com
#

cpu=0
bw=0
liquid=0
unstakecpu=0
unstakebw=0
total=0

while read name; do
        JSON=$(teclos.sh get account $name -j)
        liquid=$(echo $JSON | jq .core_liquid_balance | cut -d ' ' -f 1 | cut -d '"' -f 2)
#       liquid=$(teclos.sh get account $name -j | jq .core_liquid_balance | cut -d ' ' -f 1 | cut -d '"' -f 2)
        cpu=$(echo $JSON | jq .total_resources.cpu_weight | cut -d ' ' -f 1 | cut -d '"' -f 2)
        bw=$(echo $JSON | jq .total_resources.net_weight | cut -d ' ' -f 1 | cut -d '"' -f 2)
        unstakecpu=$(echo $JSON | jq .refund_request.cpu_amount | cut -d ' ' -f 1 | cut -d '"' -f 2)
        unstakebw=$(echo $JSON | jq .refund_request.net_amount | cut -d ' ' -f 1 | cut -d '"' -f 2)
        total=$(echo "$liquid + $cpu + $bw + $unstakecpu + $unstakebw" | bc)
        #echo $liquid
        #echo $name
        #echo $cpu
        #echo $bw
        echo $name,$total >> 6M_accountsWithBalances.csv
done <6MillionBlockAccounts.txt
