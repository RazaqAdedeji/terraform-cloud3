region = "us-east-1"

vpc_id = "aws_vpc.main.id"

vpc_cidr = "10.0.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "production"

ami-web = "ami-0ebaa3a1fcc8f1980"

ami-bastion = "ami-016011ccb46511a2b"

ami-nginx = "ami-00834050c0bec8f16"

ami-sonar = "ami-08b7d787c28b89121"

keypair = "Terraform-key"

# Ensure to change this to your acccount number
account_no = "858384426779"

master-username = "admin"

master-password = "admin2468"

tags = {
  Enviroment      = "production"
  Owner-Email     = "razaqadedeji@hotmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}