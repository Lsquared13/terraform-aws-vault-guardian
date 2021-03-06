# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "subdomain_name" {
  description = "Required; the [value] in the final '[value].[root_domain]' DNS name."
}

variable "root_domain" {
  description = "Required; the [root_domain] in the final '[value].[root_domain]' DNS name, should end in a TLD (e.g. eximchain.com)."
}

variable "okta_api_token" {
  description = "The API token to use for Okta setup"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "public_key_path" {
  description = "The path to the public key that will be used to SSH the instances in this region."
  default     = ""
}

variable "public_key" {
  description = "The path to the public key that will be used to SSH the instances in this region. Will override public_key_path if set."
  default     = ""
}

variable "private_key" {
  description = "The private key that will be used to SSH the instances in this region. Will use the agent if empty"
  default     = ""
}

variable "cert_owner" {
  description = "The OS user to be made the owner of the local copy of the vault certificates. Should usually be set to the user operating the tool."
  default     = "$USER"
}

variable "vault_port" {
  description = "The port that vault will be accessible on."
  default     = 8200
}

variable "node_availability_zones" {
  description = "AWS availability zones to distribute the eximchain nodes amongst. Must name at least two. Defaults to distributing nodes across AZs."
  default     = []
}

variable "force_destroy_s3_buckets" {
  description = "Whether or not to force destroy s3 buckets. Set to true for an easily destroyed test environment. DO NOT set to true for a production environment."
  default     = false
}

variable "vault_consul_ami" {
  description = "AMI ID to use for vault and consul servers. Defaults to getting the most recently built version from Eximchain"
  default     = ""
}

variable "vault_cluster_size" {
  description = "The number of instances to use in the vault cluster"
  default     = 3
}

variable "vault_instance_type" {
  description = "The EC2 instance type to use for vault nodes"
  default     = "t2.micro"
}

variable "consul_cluster_size" {
  description = "The number of instances to use in the consul cluster"
  default     = 3
}

variable "consul_instance_type" {
  description = "The EC2 instance type to use for consul nodes"
  default     = "t2.micro"
}

variable "cert_org_name" {
  description = "The organization to associate with the vault certificates."
  default     = "Example Co."
}

variable "vpc_cidr" {
  description = "The cidr range to use for the VPC."
  default     = "10.0.0.0/16"
}

variable "vault_log_level" {
  description = "Log level for the vault process"
  default     = "info"
}

variable "letsencrypt_webmaster" {
  description = "The email address to use as the Webmaster for Let's Encrypt certificates"
  default     = "louis@eximchain.com"
}

variable "letsencrypt_acme_server" {
  description = "The ACME server to use for Let's Encrypt certs"
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}