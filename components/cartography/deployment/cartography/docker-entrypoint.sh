#!/bin/sh
mkdir -p ~/.aws/

# Copy the config for the Spoke accounts from the configmap
cp /opt/aws-config/aws-config ~/.aws/config

# SETUP CREDS
#   [default]
#   aws_access_key_id = X
#   aws_secret_access_key = X
#   aws_session_token = x
cat <<EOF >> ~/.aws/credentials
[${AWS_DEFAULT_PROFILE}]
aws_access_key_id=$(cat /vault/secrets/aws-security-reviewer-id)
aws_secret_access_key=$(cat /vault/secrets/aws-security-reviewer-key)
EOF
