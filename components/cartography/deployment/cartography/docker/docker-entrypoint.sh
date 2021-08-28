#!/bin/bash

mkdir -p ~/.aws/

# Retrieve credentials for the security-audit-user
aws_access_key_id=$(grep access_key /vault/secrets/aws-user.txt | awk '{print $2}')
aws_secret_access_key=$(grep secret_key /vault/secrets/aws-user.txt | awk '{print $2}')
aws_session_token=$(grep security_token /vault/secrets/aws-user.txt | awk '{print $2}')

# Populate the ~/.aws/credentials file
#   [default]
#   aws_access_key_id = X
#   aws_secret_access_key = X
#   aws_session_token = x
cat <<EOF >> ~/.aws/credentials
[${AWS_DEFAULT_PROFILE}]
aws_access_key_id=$aws_access_key_id
aws_secret_access_key=$aws_secret_access_key
aws_session_token=$aws_session_token
EOF

# Populate the ~/.aws/config file
#   # SETUP CONFIG
#   [default]
#   region=eu-west-1
#   output=json
#
#   # SETUP SPOKE ACCOUNTS
#   [profile <AccountName>]
#   role_arn = arn:aws:iam::<AccountId>:role/role_security_audit
#   region=eu-west-1
#   output=json
#   source_profile=default
cat <<EOF >> ~/.aws/config
[${AWS_DEFAULT_PROFILE}]
region=${AWS_DEFAULT_REGION}
output=json
retry_mode=standard
max_attempts=6
EOF

# Fetch accounts in the Org
accounts=$(aws organizations list-accounts --query 'Accounts[?Status==`ACTIVE`]'.Id --output text)

for account_id in $accounts; do
cat <<EOF >> ~/.aws/config
[profile ${account_id}]
role_arn = arn:aws:iam::${account_id}:role/role_security_audit
region=${AWS_DEFAULT_REGION}
output=json
source_profile=${AWS_DEFAULT_PROFILE}
retry_mode=standard
max_attempts=6
EOF

done
