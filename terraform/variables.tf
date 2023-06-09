variable "region" {
  type        = string
  description = "The region to deploy resources"
}
variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC cidr"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_classiclink" {
  default = "false"
}

variable "enable_classiclink_dns_support" {
  default = "false"
}

variable "preferred_number_of_public_subnets" {
  default     = null
  type        = number
  description = "Number of private subnets to be created"
}

variable "preferred_number_of_private_subnets" {
  default     = null
  type        = number
  description = "Number of private subnets to be created"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  default = "ACS"
  type    = string
}

variable "ami-web" {
  type        = string
  description = "AMI ID for the launch template"
}

variable "ami-bastion" {
  type        = string
  description = "AMI ID for the launch template"
}

variable "ami-nginx" {
  type        = string
  description = "AMI ID for the launch template"
}

variable "ami-sonar" {
  type        = string
  description = "AMI ID for the launch template"
}
variable "keypair" {
  type        = string
  description = "key pair for the instances"
}

variable "account_no" {
  type        = number
  description = "the account number"
}

variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}

