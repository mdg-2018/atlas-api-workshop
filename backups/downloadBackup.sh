#!/bin/bash
. ../env.config

CLUSTER=sample
TARGET=restore-target

#use the getBackups.sh script to get snapshot id
SNAPSHOTID=5fb73d856e2e0e2c8c68115e

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest --include \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}/backup/restoreJobs" \
  --data "
    {
      \"snapshotId\" : \"$SNAPSHOTID\",
      \"deliveryType\" : \"download\"
    }
  "