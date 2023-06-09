
# creating VPC
module "network" {
  source                              = "./modules/network"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_classiclink                  = var.enable_classiclink
  vpc_id                              = var.vpc_id
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

#Module for Application Load balancer, this will create Extenal Load balancer and internal load balancer
module "ALB" {
  source             = "./modules/ALB"
  name               = "ACS-ext-alb"
  vpc_id             = module.network.vpc_id
  public-sg          = module.security.ALB-sg
  private-sg         = module.security.IALB-sg
  public-subnet-1    = module.network.public_subnets-1
  public-subnet-2    = module.network.public_subnets-2
  private-subnet-1   = module.network.private_subnets-1
  private-subnet-2   = module.network.private_subnets-2
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}


module "autoscaling" {
  source            = "./modules/autoscaling"
  ami-web           = var.ami-web
  ami-bastion       = var.ami-bastion
  ami-nginx         = var.ami-nginx
  desired_capacity  = 1
  min_size          = 1
  max_size          = 1
  web-sg            = [module.security.web-sg]
  bastion-sg        = [module.security.bastion-sg]
  nginx-sg          = [module.security.nginx-sg]
  wordpress-alb-tgt = module.ALB.wordpress-tgt
  nginx-alb-tgt     = module.ALB.nginx-tgt
  tooling-alb-tgt   = module.ALB.tooling-tgt
  instance_profile  = module.network.instance_profile
  public_subnets    = [module.network.public_subnets-1, module.network.public_subnets-2]
  private_subnets   = [module.network.private_subnets-1, module.network.private_subnets-2]
  keypair           = var.keypair

}

# Module for Elastic Filesystem; this module will creat elastic file system isn the webservers availablity
# zone and allow traffic fro the webservers

module "EFS" {
  source       = "./modules/EFS"
  efs-subnet-1 = module.network.private_subnets-1
  efs-subnet-2 = module.network.private_subnets-2
  efs-sg       = [module.security.datalayer-sg]
  account_no   = var.account_no
}

# RDS module; this module will create the RDS instance in the private subnet

module "RDS" {
  source          = "./modules/RDS"
  master-password = var.master-password
  master-username = var.master-username
  db-sg           = [module.security.datalayer-sg]
  private_subnets = [module.network.private_subnets-3, module.network.private_subnets-4]
}

# The Module creates instances for jenkins, sonarqube abd jfrog
# module "compute" {
#  source          = "./modules/compute"
#  ami-jenkins     = var.ami
#  ami-sonar       = var.ami
#  ami-jfrog       = var.ami
#  subnets-compute = module.network.public_subnets-1
#  sg-compute      = [module.security.ALB-sg]
#  keypair         = var.keypair
# }