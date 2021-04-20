#!/bin/bash
. ../env.config

### This script provides an example of how downloading backups from Atlas can be automated.


#use the getBackups.sh script to get snapshot id
SNAPSHOTID=607d6d73a8ff021128c5c29d
CLUSTER=sample


RESTOREID=$(curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
    --header "Accept: application/json" \
    --header "Content-Type: application/json" \
    --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}/backup/restoreJobs?pretty=true" \
    --data "
        {
        \"snapshotId\" : \"$SNAPSHOTID\",
        \"deliveryType\" : \"download\"
        }
    " | jq -r '.id')

echo "Restore-Job-ID: $RESTOREID"

i=0

while true
do 
    DOWNLOAD_URL=$(curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
        --header "Accept: application/json" \
        --header "Content-Type: application/json" \
        --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}/backup/restoreJobs/${RESTOREID}?pretty=true" | jq '.deliveryUrl')

    ((i++))

    if [[ "$DOWNLOAD_URL" != [] ]]; then
        echo "Ready to Download! URL: $DOWNLOAD_URL"
        break
    fi

    echo "Preparing Backup Download... $i"
    sleep 1
done
