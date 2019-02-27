#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-consul script to configure and start Consul in server mode. Note that this script assumes it's running in an AMI
# built from the Packer template in examples/vault-consul-ami/vault-consul.json.

set -eu

readonly BASH_PROFILE_FILE="/home/ubuntu/.bash_profile"
readonly VAULT_TLS_CERT_DIR="/opt/vault/tls"
readonly CA_TLS_CERT_FILE="$VAULT_TLS_CERT_DIR/ca.crt.pem"

# This is necessary to retrieve the address for vault
echo "export VAULT_ADDR=https://${vault_dns}:${vault_port}" >> $BASH_PROFILE_FILE
source $BASH_PROFILE_FILE

sleep 60

function write_data {
  echo "${disable_authentication}" | sudo tee /opt/guardian/info/disable-authentication.txt > /dev/null 2>&1
  echo "${custom_domain}" | sudo tee /opt/guardian/info/custom-domain.txt > /dev/null 2>&1
  echo "${enable_https}" | sudo tee /opt/guardian/info/enable-https.txt > /dev/null 2>&1
}

function write_nginx_config {
  sudo rm -rf /etc/nginx/sites-enabled/default
  local readonly HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/public-hostname)"
  local readonly HTTP_PORT="80"
  local readonly GOKIT_URL="http://localhost:8080"
  if [ "${using_custom_domain}" == "true" ]
  then
    local readonly SERVER_NAME="${custom_domain} $HOSTNAME"
  else
    local readonly SERVER_NAME="$HOSTNAME"
  fi
  echo "
  server {
    listen $HTTP_PORT;
    server_name $SERVER_NAME;
    location / {
      proxy_pass \"$GOKIT_URL\";
    }
  }" | sudo tee /etc/nginx/sites-available/guardian > /dev/null 2>&1
  sudo ln -s /etc/nginx/sites-available/guardian /etc/nginx/sites-enabled/guardian
  sudo service nginx restart
}

function download_vault_certs {
  # Download vault certs from s3
  aws configure set s3.signature_version s3v4
  while [ -z "$(aws s3 ls s3://${vault_cert_bucket}/ca.crt.pem)" ]
  do
      echo "S3 object not found, waiting and retrying"
      sleep 5
  done
  while [ -z "$(aws s3 ls s3://${vault_cert_bucket}/vault.crt.pem)" ]
  do
      echo "S3 object not found, waiting and retrying"
      sleep 5
  done
  aws s3 cp s3://${vault_cert_bucket}/ca.crt.pem $VAULT_TLS_CERT_DIR
  aws s3 cp s3://${vault_cert_bucket}/vault.crt.pem $VAULT_TLS_CERT_DIR

  # Set ownership and permissions
  sudo chown ubuntu $VAULT_TLS_CERT_DIR/*
  sudo chmod 600 $VAULT_TLS_CERT_DIR/*
  sudo /opt/vault/bin/update-certificate-store --cert-file-path $CA_TLS_CERT_FILE
}

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

download_vault_certs
write_data
write_nginx_config

# These variables are passed in via Terraform template interpolation
/opt/consul/bin/run-consul --client --cluster-tag-key "${consul_cluster_tag_key}" --cluster-tag-value "${consul_cluster_tag_value}"

/opt/guardian/bin/generate-run-init-guardian ${vault_dns} ${vault_port}
/opt/guardian/bin/run-init-guardian