#here we declare All modules calls from modules folder
#My Vpc Creation block
module "vpc" {
  source              = "../../modules/vpc"
  name                = "3TierVpc_pavan"
  cidr_block          = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_app_subnets = var.private_app_subnets
  private_db_subnets  = var.private_db_subnets
  availability_zones  = var.availability_zones
  project             = var.project
  owner               = var.owner
}

#My security groups creation block
module "security_groups" {
  source = "../../modules/security_groups"
  vpc_id = module.vpc.vpc_id
  project = var.project
  owner = var.owner
}

module "iam" {
  source = "../../modules/iam"
  project = var.project
  owner   = var.owner
}

module "alb" {
  source = "../../modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_alb_id = module.security_groups.sg_alb_id
  project = var.project
  owner = var.owner
}

module "web_asg" {
  source = "../../modules/asg"
  name = "web"
  ami = var.web_ami
  instance_type = var.web_instance_type
  subnet_ids = module.vpc.public_subnet_ids
  security_group_ids = [module.security_groups.sg_web_id]
  iam_instance_profile = module.iam.instance_profile_name
  desired_capacity = 1
  min_size = 1
  max_size = 2
  target_group_arns = [module.alb.web_tg_arn]
  project = var.project
  owner = var.owner
}

module "app_asg" {
  source = "../../modules/asg"
  name = "app"
  ami = var.app_ami
  instance_type = var.app_instance_type
  subnet_ids = module.vpc.private_app_subnet_ids
  security_group_ids = [module.security_groups.sg_app_id]
  iam_instance_profile = module.iam.instance_profile_name
  desired_capacity = 1
  min_size = 1
  max_size = 2
  project = var.project
  owner = var.owner
}

module "rds" {
  source              = "../../modules/rds"
  db_password         = var.db_password
  sg_db_id            = module.security_groups.sg_db_id
  username            = var.db_username
  password            = var.db_password
  db_subnet_ids       = module.vpc.private_db_subnet_ids
  owner               = var.owner
  project             = var.project
  engine              = var.db_engine
  instance_class      = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  multi_az            = var.db_multi_az
}




  
