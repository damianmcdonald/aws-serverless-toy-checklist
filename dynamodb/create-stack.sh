#!/bin/bash

# script parameters
PROJECT_DIR=$1
DYNAMODB_TABLENAME=$2

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
DB_PAYLOAD_SCRIPT=$PROJECT_DIR/dynamodb/create-payload.sh
DATALOAD_FILE_1=$PROJECT_DIR/dynamodb/dataload-1.json
DATALOAD_FILE_2=$PROJECT_DIR/dynamodb/dataload-2.json

###########################################################
#                                                         #
#  Load data content to DynamoDB tables                   #
#                                                         #
###########################################################
# create the payload for the dynamodb
echo -e "[${LIGHT_BLUE}INFO${NC}] Creating the data item content for load into DynamoDB table ${YELLOW}$DYNAMODB_TABLENAME${NC}";
$DB_PAYLOAD_SCRIPT $DYNAMODB_TABLENAME
echo -e "[${LIGHT_BLUE}INFO${NC}] Loading data content to DynamoDB table from ${YELLOW}$DATALOAD_FILE_1${NC}";
aws dynamodb batch-write-item --request-items file://$DATALOAD_FILE_1
echo -e "[${LIGHT_BLUE}INFO${NC}] Loading data content to DynamoDB table from ${YELLOW}$DATALOAD_FILE_2${NC}";
aws dynamodb batch-write-item --request-items file://$DATALOAD_FILE_2
