#!/usr/bin/env bash

if [ $# -ne 2 ]
then 
    echo "usage is: $0 <URL to POST to> <json file to post>"
    exit 1
fi


URL=$1
JSON_FILE=$2


curl -X POST -d @$JSON_FILE $URL --header "Content-Type:application/json"
