provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "12.0.0.0/16"
  public_subnet     = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "webserver" {
  source            = "./modules/instance"
  ec2_instance_name = ["jenkins-master", "build-slave", "ansible"]
  instance_type     = "t2.micro"
  sg_name           = "demo-sg"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet[0].id
  port              = 8080
}

module "sonar_server" {
  source            = "./modules/instance"
  ec2_instance_name = ["sonar-server"]
  sg_name           = "sonar-sg"
  instance_type     = "t2.small"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet[0].id
  port              = 80
}

module "eks_sg" {
  source = "./modules/sg_eks"
  vpc_id = module.vpc.vpc_id
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet[0].id, module.vpc.public_subnet[1].id]
  sg_ids     = module.eks_sg.security_group_public
}
