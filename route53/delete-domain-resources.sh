#!/bin/bash

# script parameters
PROJECT_DIR=$1

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

###########################################################
#                                                         #
#  Global variable declarations                           #
#                                                         #
###########################################################
CNAME_DNS_NAME=www.dcorp.info
CNAME_RESOURCE_VALUE=www.dcorp.info.s3.eu-west-1.amazonaws.com
CNAME_RECORD_TYPE=CNAME
A_DNS_NAME=dcorp.info.
A_RESOURCE_VALUE=s3-website-eu-west-1.amazonaws.com.
A_RECORD_TYPE=A
TTL=900
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones --output text --query "HostedZones[?Name == '$A_DNS_NAME'][Id]")
ALIAS_ZONE_ID=$(aws route53 list-resource-record-sets --hosted-zone-id=${HOSTED_ZONE_ID} | jq -r --arg DNS_NAME "$A_DNS_NAME" --arg A_TYPE "$A_RECORD_TYPE" '.ResourceRecordSets[] | select (.Name == $DNS_NAME) | select (.Type == $A_TYPE).AliasTarget.HostedZoneId')


###########################################################
#                                                         #
#  Delete specific route53 hosted zone record sets        #
#                                                         #
###########################################################

# list the record sets
# aws route53 list-resource-record-sets --hosted-zone-id=${HOSTED_ZONE_ID} | jq '.ResourceRecordSets[] | select (.Name == "dcorp.info.")'

DNS_RECORDS_FILE=$PROJECT_DIR/route53/dns-records.json

# delete any previous instance of DNS_RECORDS_FILE
if [ -f "$DNS_RECORDS_FILE" ]; then
    rm $DNS_RECORDS_FILE
fi


(
cat <<EOF
{
    "Comment": "Delete single record set",
    "Changes": [
    	{
            "Action": "DELETE",
            "ResourceRecordSet": {
			  "Name": "$A_DNS_NAME",
			  "Type": "A",
			  "AliasTarget": {
			    "HostedZoneId": "$ALIAS_ZONE_ID",
			    "DNSName": "$A_RESOURCE_VALUE",
    	  		"EvaluateTargetHealth": false
	  		  }
			}
        },
        {
            "Action": "DELETE",
            "ResourceRecordSet": {
                "Name": "$CNAME_DNS_NAME.",
                "Type": "$CNAME_RECORD_TYPE",
                "TTL": $TTL,
                "ResourceRecords": [
                    {
                        "Value": "$CNAME_RESOURCE_VALUE"
                    }
                ]
            }
        }
    ]
}
EOF
) > $DNS_RECORDS_FILE

echo "Deleting DNS Record set"
aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --change-batch file://$DNS_RECORDS_FILE
