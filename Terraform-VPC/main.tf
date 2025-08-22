module "vpc" {
  source     = "./modules/VPC"
  vpc_cidr   = var.vpc_cidr
  subnet_vpc = var.subnet_vpc
}


module "sg" {
  source = "./modules/SG"
  vpc_id = module.vpc.vpc_id #taking this from the above module's output 
}


module "ec2" {
  source  = "./modules/EC2"
  sg_id   = module.sg.sg_id
  subnets = module.vpc.subnet_id
}

module "alb" {
  source    = "./modules/ALB"
  sg_id     = module.sg.sg_id
  subnets   = module.vpc.subnet_id
  vpc_id    = module.vpc.vpc_id
  instances = module.ec2.instances
}