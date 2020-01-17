#!/bin/bash

###########################################################################
#                                                                         #
# This sample demonstrates the following concepts:                        #
#                                                                         #
# * AWS CLI                                                               #
# * AWS Cloudformation                                                    #
# * AWS Cloudformation using nested stacks                                #
# * S3 Bucket creation                                                    #
# * S3 Bucket for static website hosting                                  #
# * S3 Bucket with URL redirection                                        #
# * Route 53 public hosted zone creation                                  #
# * Route 53 A record creation                                            #
# * Route 53 Alias target                                                 #
# * DynamoDB table creation                                               #
# * DynamoDB Local Secondary Index creation                               #
# * DynamoDB auto scaling read/write                                      #
# * Cleans up all the resources created                                   #
#                                                                         #
###########################################################################

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

# the root project directory
PROJECT_DIR=$PWD
# generic project name
PROJECT_NAME=toychecklist
# parent cloudformation stack
CFN_PARENT_STACK=parent-stack.yml
# nested stack directories
DYNAMODB_DIR=dynamodb
S3_DIR=s3
SAM_DIR=sam
ROUTE53_DIR=route53
# nested stack scripts
DYNAMODB_SCRIPT=${DYNAMODB_DIR}/create-stack.sh
S3_SCRIPT=${S3_DIR}/create-stack.sh
SAM_SCRIPT=${SAM_DIR}/create-stack.sh
ROUTE53_DELETE_SCRIPT=${ROUTE53_DIR}/delete-domain-resources.sh
S3_DELETE_SCRIPT=${S3_DIR}/remove-s3-objects.sh
# nested stack scripts addtional parameters
API_STAGE_NAME=dev
LAMBDA_FUNCTIONS_BUCKET=lambda-functions
# nested cloudformation stacks
CFN_ROUTE53_STACK=${ROUTE53_DIR}/route53-stack.yml
CFN_S3_STACK=${S3_DIR}/s3-stack.yml
CFN_DYNAMODB_STACK=${DYNAMODB_DIR}/dynamodb-stack.yml
CFN_SAM_STACK=${SAM_DIR}/sam-stack.yml
# cloudformation templates to validate
CFN_TEMPLATES=($CFN_PARENT_STACK $CFN_S3_STACK $CFN_ROUTE53_STACK $CFN_DYNAMODB_STACK $CFN_SAM_STACK)
# cloudformation parameters
IAM_CAPABILITIES=CAPABILITY_IAM
CFN_RESOURCES_BUCKET=cloudformationresourcesdcorp
DNS_DOMAIN=dcorp.info
# script name to destroy the stack
UNDEPLOY_FILE=destroy-stack.sh

###########################################################
#                                                         #
#  Validate the CloudFormation templates                  #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] Validating CloudFormation templates";

for CFN_STACK in ${CFN_TEMPLATES[@]}; do
  echo -e "[${LIGHT_BLUE}INFO${NC}] Validating CloudFormation template ${YELLOW}$CFN_STACK${NC}";
  cat $CFN_STACK | xargs -0 aws cloudformation validate-template --template-body
  # assign the exit code to a variable
  TEMPLATE_VALIDAION_CODE="$?"

  # check the exit code, 255 means the CloudFormation template was not valid
  if [ $TEMPLATE_VALIDAION_CODE != "0" ]; then
      echo -e "[${RED}FATAL${NC}] CloudFormation template ${YELLOW}$CFN_STACK${NC} failed validation with non zero exit code ${YELLOW}$TEMPLATE_VALIDAION_CODE${NC}. Exiting.";
      exit 999;
  fi

  echo -e "[${GREEN}SUCCESS${NC}] CloudFormation template ${YELLOW}$CFN_STACK${NC} is valid.";
done

###########################################################
#                                                         #
#  Execute the CloudFormation base stack                  #
#                                                         #
###########################################################

# Create the application resources using nested stacks
echo -e "[${LIGHT_BLUE}INFO${NC}] Creating application using parent template ${YELLOW}$CFN_PARENT_STACK${NC}";
for CFN_STACK in ${CFN_TEMPLATES[@]}; do
  echo -e "[${LIGHT_BLUE}INFO${NC}] Using nested template ${YELLOW}$CFN_STACK${NC} ...";
done

aws cloudformation deploy --template-file $CFN_PARENT_STACK \
    --stack-name $PROJECT_NAME \
    --parameter-overrides CfnResourcesS3Bucket=$CFN_RESOURCES_BUCKET RootDomainName=$DNS_DOMAIN BillingCode=$PROJECT_NAME \
    --capabilities $IAM_CAPABILITIES

###########################################################
#                                                         #
#  Populate the DynamoDB tables                           #
#                                                         #
###########################################################

# Generate the data load files and populate the DynamoDB tables
DYNAMODB_TABLENAME=$(aws dynamodb list-tables --output text --query 'TableNames[*]' | grep $PROJECT_NAME)
echo -e "[${LIGHT_BLUE}INFO${NC}] Generate the data load files and populate the DynamoDB table ${YELLOW}$DYNAMODB_TABLENAME${NC} ....";
cd $DYNAMODB_DIR
# pass in parameters for
# * root directory of the project
# * DynamoDB table name
$PROJECT_DIR/$DYNAMODB_SCRIPT $PROJECT_DIR $DYNAMODB_TABLENAME
cd $PROJECT_DIR

###########################################################
#                                                         #
#  Create the serverless API and Lambda functions         #
#                                                         #
###########################################################

echo -e "[${LIGHT_BLUE}INFO${NC}] Execute the creation of the SAM stack ....";
cd $SAM_DIR
# pass in parameters for
# * DynamoDB table name
# * Project name
# * API stage name
# * Cloudformation resources bucket
# * Lambda functions resources bucket
# * path to root project directory
$PROJECT_DIR/$SAM_SCRIPT $DYNAMODB_TABLENAME $PROJECT_NAME $API_STAGE_NAME $CFN_RESOURCES_BUCKET $LAMBDA_FUNCTIONS_BUCKET $PROJECT_DIR
cd $PROJECT_DIR

###########################################################
#                                                         #
#  Copy the static web site resources to the S3 bucket    #
#                                                         #
###########################################################

echo -e "[${LIGHT_BLUE}INFO${NC}] Execute the creation of the SAM stack ....";
cd $S3_DIR
# pass in parameters for
# * S3 Website bucket name (same as root dns domian)
# * API name (same as the name of the project)
# * path to root project directory
$PROJECT_DIR/$S3_SCRIPT $DNS_DOMAIN $PROJECT_NAME $PROJECT_DIR
cd $PROJECT_DIR

###########################################################
#                                                         #
# Undeployment file creation                              #
#                                                         #
###########################################################

# delete any previous instance of undeploy.sh
if [ -f "$UNDEPLOY_FILE" ]; then
    rm $UNDEPLOY_FILE
fi

cat > $UNDEPLOY_FILE <<EOF
#!/bin/bash

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

echo -e "[${LIGHT_BLUE}INFO${NC}] Terminating Route53 stack ${YELLOW}$CFN_ROUTE53_STACK${NC} ....";
# delete the record set created as part of the stack
$ROUTE53_DELETE_SCRIPT $PROJECT_DIR

echo -e "[${LIGHT_BLUE}INFO${NC}] Terminating S3 stack ${YELLOW}$CFN_S3_STACK${NC} ....";
# as CFN can only delete empty S3 buckets, we need to empty the buckets first
aws s3 rm s3://www.$DNS_DOMAIN --recursive
aws s3 rm s3://$DNS_DOMAIN --recursive
$S3_DELETE_SCRIPT $DNS_DOMAIN
aws s3 rb s3://www.$DNS_DOMAIN --force
aws s3 rb s3://$DNS_DOMAIN --force

echo -e "[${LIGHT_BLUE}INFO${NC}] Deleting the nested stacks";

aws cloudformation list-stacks \
| jq -r '.StackSummaries[] | select(.StackStatus == "CREATE_COMPLETE") | select(.StackName | startswith("$PROJECT_NAME")) | .StackName' \
| while read stack; do echo -e "[${LIGHT_BLUE}INFO${NC}] Removing nested template ${YELLOW}\$stack${NC}"; aws cloudformation delete-stack --stack-name \$stack; done

echo -e "[${LIGHT_BLUE}INFO${NC}] Terminating SAM stack ${YELLOW}$CFN_SAM_STACK${NC} ....";
aws cloudformation delete-stack --stack-name sam-stack

aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE
EOF

chmod +x $UNDEPLOY_FILE
