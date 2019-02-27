# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "availability_zone" {
  description = "AWS availability zone to launch the transaction executor in"
}

variable "aws_vpc" {
  description = "The VPC to create the transaction executor in"
}

variable "aws_route" {
  description = "The ID of the required route in the aws_vpc routing table.  Enforces networking dependency."
}

variable "public_key" {
  description = "The public key that will be used to SSH the instances in this region."
}

variable "cert_owner" {
  description = "The OS user to be made the owner of the local copy of the vault certificates. Should usually be set to the user operating the tool."
}

variable "vault_dns" {
  description = "The DNS name that vault will be accessible on."
}

variable "vault_cert_bucket_name" {
  description = "The name of the S3 bucket holding the vault TLS certificates"
}

variable "vault_cert_bucket_arn" {
  description = "The ARN of the S3 bucket holding the vault TLS certificates"
}

variable "consul_cluster_tag_key" {
  description = "The tag key of the consul cluster to use for vault cluster locking."
}

variable "consul_cluster_tag_value" {
  description = "The tag value of the consul cluster to use for vault cluster locking."
}

variable "vault_cert_s3_upload_id" {
  description = "Generated by guardian_vault after uploading certificates to S3. Used to work around lack of depends_on for modules."
}

variable "enable_https" {
  description = "Boolean string controlling whether to enable HTTPS connections.  If true, subdomain_name and root_domain are required."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "vault_port" {
  description = "The port that vault will be accessible on."
  default     = 8200
}

variable "disable_authentication" {
  description = "Whether or not the tx executor should disable token authentication. Should be a either 'true' or 'false' in string form."
  default     = "false"
}

variable "private_key" {
  description = "The private key that will be used to SSH the instances in this region. Will use the agent if empty"
  default     = ""
}

variable "rpc_api_cidrs" {
  description = "List of CIDRs to grant access to the rpc API."
  default     = []
}

variable "rpc_api_security_groups" {
  description = "List of security groups to grant access to the rpc API."
  default     = []
}

variable "force_destroy_s3_buckets" {
  description = "Whether or not to force destroy s3 buckets. Set to true for an easily destroyed test environment. DO NOT set to true for a production environment."
  default     = false
}

variable "guardian_ami" {
  description = "AMI ID to use for transaction executor servers. Defaults to getting the most recently built version from Eximchain"
  default     = ""
}

variable "guardian_instance_type" {
  description = "The EC2 instance type to use for transaction executor nodes"
  default     = "t2.medium"
}

variable "base_subnet_cidr" {
  description = "The cidr range to use for subnets."
  default     = "10.0.0.0/16"
}

variable "subdomain_name" {
  description = "Required if using HTTPS; the [value] in the final '[value].[root_domain]' DNS name."
  default     = ""
}

variable "root_domain" {
  description = "Required if using HTTPS; the [root_domain] in the final '[value].[root_domain]' DNS name, should end in a TLD (e.g. eximchain.com)."
  default     = ""
}