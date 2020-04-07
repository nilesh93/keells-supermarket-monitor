#!/bin/bash

AVAIL="Available"
UNAVAIL="Unavailable"




cities=( "Gampaha" "Kurunegala" "Wadduwa" )
declare -A status

for city in "${cities[@]}"
do
    status[$city]="N/A"
done

curl --header "Content-Type: application/json" \
 --request POST \
 --data "{'text':'keells availability monitor started'}" \
 "$CRON_URL"

i=1
while [ "$i" -ne 0 ]
do
    RESPONSE=$(curl https://int.keellssuper.net/login)
    for city in "${cities[@]}"
    do
    echo $(date)
    echo "processing ${city}"
    echo "${city} current status ${status[$city]}"
    RESULT=$(echo "$RESPONSE" | grep "$city")

    if [ "$RESULT" = "" ]; then
        echo "$city unavailable"
       
        if [ ${status[$city]} != $UNAVAIL ]; then
            echo "Sending notification to city $city"

            curl --header "Content-Type: application/json" \
            --request POST \
            --data "{'text':'keells online ordering quota full for $city '}" \
            "$CRON_URL"

            status[$city]=$UNAVAIL
            echo "$city saved status: ${status[$city]}"
        else
            echo "$city unavailable and already processed"
        fi
    else
        echo "$city available"
        if [ ${status[$city]} != $AVAIL ]; then
            echo "Sending notification to city $city"

            curl --header "Content-Type: application/json" \
            --request POST \
            --data "{'text':'keells online ordering available for $city. Login here: https://int.keellssuper.net/login'}" \
            "$CRON_URL"

            status[$city]=$AVAIL
            echo "$city saved status: ${status[$city]}"
        else
            echo "$city available and already processed"
        fi
    fi
    done
    echo "-----------------"
    sleep 60
done
 


