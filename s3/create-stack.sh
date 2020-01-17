#!/bin/bash

# script parameters
BUCKET_NAME=$1
API_NAME=$2
PROJECT_DIR=$3

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

# Global variable declarations
AWS_REGION=$(aws configure get region)
API_GATEWAY_ID=$(aws apigateway get-rest-apis --output json | jq -r --arg API_NAME "$API_NAME" '.items[] | select(.name | startswith($API_NAME)) | .id')
API_STAGE_NAME=$(aws apigateway get-stages --rest-api-id=$API_GATEWAY_ID --output text --query 'item[0].stageName')
PROPERTIES_FILE=$PROJECT_DIR/s3/website/starwars/js/properties.js

###########################################################
#                                                         #
#  Inject the S3 and API gateway URLs                     #
#  into $PROPERTIES_FILE                                  #
#                                                         #
###########################################################
IMAGE_BUCKET_URL="https://s3.${AWS_REGION}.amazonaws.com/${BUCKET_NAME}/";
API_GATEWAY_URL="https://${API_GATEWAY_ID}.execute-api.${AWS_REGION}.amazonaws.com/${API_STAGE_NAME}/starwars";

# delete any previous instance of PROPERTIES_FILE
if [ -f "$PROPERTIES_FILE" ]; then
    rm $PROPERTIES_FILE
fi

cat > $PROPERTIES_FILE <<EOF
/* Properties defining the dynamic locations of the S3 bucket and API Gateway */
var IMAGE_BUCKET_URL="$IMAGE_BUCKET_URL";
var API_GATEWAY_URL="$API_GATEWAY_URL";
EOF

###########################################################
#                                                         #
#  Copy the webiste content to S3 Bucket                  #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] Copying webiste content from ${YELLOW}${PROJECT_DIR}/s3/website${NC} to ${YELLOW}s3://$BUCKET_NAME${NC}";
aws s3 cp $PROJECT_DIR/s3/website s3://$BUCKET_NAME --recursive --acl public-read