#!/bin/bash

AVAIL="Available"
UNAVAIL="Unavailable"


RESPONSE=$(curl https://int.keellssuper.net/login)

cities=( "Gampaha" "Kurunegala" "Wadduwa" )
declare -A statuses
            curl --header "Content-Type: application/json" \
            --request POST \
            --data "{'text':'keells availability monitor started'}" \
            "$CRON_URL"

i=1
while [ "$i" -ne 0 ]
do
    for city in "${cities[@]}"
    do
    echo "${city}"
    RESULT=$(echo "$RESPONSE" | grep "$city")

    if [ "$RESULT" = "" ]; then
        echo "$city unavailable"
        if [ statuses["$city"] != "$UNAVAIL" ]; then
            echo "Sending notification to city $city"
            curl --header "Content-Type: application/json" \
            --request POST \
            --data "{'text':'keells online ordering quota full for $city '}" \
            "$CRON_URL"
            statuses["$city"]="$UNAVAIL"
        fi
    else
        echo "$city available"
        if [ statuses["$city"] != "$AVAIL" ]; then
            echo "Sending notification to city $city"
            curl --header "Content-Type: application/json" \
            --request POST \
            --data "{'text':'keells online ordering available for $city. Login here: https://int.keellssuper.net/login'}" \
            "$CRON_URL"
            statuses["$city"]="$AVAIL"
        fi
    fi
    done
    sleep 10
done
 


