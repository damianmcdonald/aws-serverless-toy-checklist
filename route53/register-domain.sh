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

# Global variable declarations
DOMAIN_REGISTRATION_FILE=register-domain.json
ROOT_DNS_DOMAIN=dcorp.info

###########################################################
#                                                         #
#  Register the Route53 domain                            #
#                                                         #
###########################################################
echo -e "[${LIGHT_BLUE}INFO${NC}] Registering the Route53 domain for ${YELLOW}$ROOT_DNS_DOMAIN${NC} ....";
# specify region as us-east-1 as Route53 only has a single global endpoint
aws route53domains register-domain --region us-east-1 --cli-input-json file://$DOMAIN_REGISTRATION_FILE
