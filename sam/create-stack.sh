#!/bin/bash

# script parameters
DYNAMODB_TABLENAME=$1
API_NAME=$2
API_STAGE_NAME=$3
CFN_RESOURCES_BUCKET=$4
LAMBDA_FUNCTIONS_BUCKET=$5
PROJECT_DIR=$6

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
CFN_LAMBDA_PREFIX=${API_NAME}/${LAMBDA_FUNCTIONS_BUCKET}
SAM_STACK_FILE=${PROJECT_DIR}/sam/sam-stack.yml
STACK_NAME=sam-stack
OUTPUT_FILE=${PROJECT_DIR}/sam/sam-stack-output.yml
AWS_REGION=$(aws configure get region)

###########################################################
#                                                         #
#  Validate the CloudFormation template                   #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] Validating CloudFormation template ${YELLOW}$SAM_STACK_FILE${NC}";
cat $SAM_STACK_FILE | xargs -0 aws cloudformation validate-template --template-body
# assign the exit code to a variable
TEMPLATE_VALIDAION_CODE="$?"

# check the exit code, 255 means the CloudFormation template was not valid
if [ $TEMPLATE_VALIDAION_CODE != "0" ]; then
  echo -e "[${RED}FATAL${NC}] CloudFormation template ${YELLOW}$SAM_STACK_FILE${NC} failed validation with non zero exit code ${YELLOW}$TEMPLATE_VALIDAION_CODE${NC}. Exiting.";
  exit 999;
fi

echo -e "[${GREEN}SUCCESS${NC}] CloudFormation template ${YELLOW}$SAM_STACK_FILE${NC} is valid.";


###########################################################
#                                                         #
#  Build the SAM functions                                #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] building the SAM functions";
cd $PROJECT_DIR/sam/src
npm install
# npm run-script lint
echo -e "[${LIGHT_BLUE}INFO${NC}] creating a production release";
npm prune --production
cd $PROJECT_DIR/sam

###########################################################
#                                                         #
#  Package the SAM stack                                  #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] packaging the SAM stack ....";
echo -e "aws cloudformation package --template-file $SAM_STACK_FILE --output-template-file $OUTPUT_FILE --s3-bucket $CFN_RESOURCES_BUCKET --s3-prefix $CFN_LAMBDA_PREFIX"
aws cloudformation package --template-file $SAM_STACK_FILE --output-template-file $OUTPUT_FILE --s3-bucket $CFN_RESOURCES_BUCKET --s3-prefix $CFN_LAMBDA_PREFIX

###########################################################
#                                                         #
#  Deploy the SAM stack                                   #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] deploying the SAM stack ....";
echo -e "aws cloudformation deploy --template-file $OUTPUT_FILE --stack-name $STACK_NAME --parameter-overrides StageName=$API_STAGE_NAME CfnResourcesS3Bucket=$CFN_RESOURCES_BUCKET BillingCode=$API_NAME ParentStackName=$API_NAME StarWarsTable=$DYNAMODB_TABLENAME  --capabilities CAPABILITY_IAM"
aws cloudformation deploy --template-file $OUTPUT_FILE --stack-name $STACK_NAME --parameter-overrides StageName=$API_STAGE_NAME CfnResourcesS3Bucket=$CFN_RESOURCES_BUCKET BillingCode=$API_NAME ParentStackName=$API_NAME StarWarsTable=$DYNAMODB_TABLENAME  --capabilities CAPABILITY_IAM

###########################################################
#                                                         #
#  Deploy the API Gateway                                 #
#                                                         #
###########################################################
# API_GATEWAY_ID=$(aws apigateway get-rest-apis --output text --query 'items[?starts_with(name, `toychecklist`) == `true`][id]')
API_GATEWAY_ID=$(aws apigateway get-rest-apis --output json | jq -r --arg API_NAME "$API_NAME" '.items[] | select(.name | startswith($API_NAME)) | .id')
echo -e "aws apigateway create-deployment --region ${AWS_REGION} --rest-api-id ${API_GATEWAY_ID} --stage-name ${API_STAGE_NAME}"
aws apigateway create-deployment --region ${AWS_REGION} --rest-api-id ${API_GATEWAY_ID} --stage-name ${API_STAGE_NAME}