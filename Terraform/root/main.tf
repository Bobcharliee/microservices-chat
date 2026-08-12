module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr_block = var.vpc_cidr_block
  aws_region = var.aws_region
  pub_subnet_1a_cidr_block = var.pub_subnet_1a_cidr_block
  pub_subnet_2a_cidr_block = var.pub_subnet_2a_cidr_block
  priv_subnet_1a_cidr_block = var.priv_subnet_1a_cidr_block
  priv_subnet_1b_cidr_block = var.priv_subnet_1b_cidr_block
  priv_subnet_2a_cidr_block = var.priv_subnet_2a_cidr_block
  priv_subnet_2b_cidr_block = var.priv_subnet_2b_cidr_block
}

module "nat" {
  source = "./modules/nat"
  project_name = var.project_name
  pub_subnet_1a_id = module.vpc.pub_subnet_1a_id
  pub_subnet_1b_id = module.vpc.pub_subnet_2a_id
  priv_subnet_1a_id = module.vpc.priv_subnet_1a_id
  priv_subnet_1b_id = module.vpc.priv_subnet_1b_id
  priv_subnet_2a_id = module.vpc.priv_subnet_2a_id
  priv_subnet_2b_id = module.vpc.priv_subnet_2b_id
  vpc_id = module.vpc.vpc_id
}

module "s3" {
  source = "./modules/s3"
}

module "asg" {
  source = "./modules/asg"
  project_name = var.project_name
  security_group_ids = [module.security_groups.app_server_sg_id]
  subnet_ids = [module.vpc.priv_subnet_1a_id, module.vpc.priv_subnet_2a_id]
  instance_type = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  key_name = var.key_name
  target_group_arn = module.alb.target_group_arn
  secrets_arn = module.secrets_manager.ms_db_secrets_arn
  chat_front_ecr_arn = module.ecr.chat_front_ecr_arn
  chat_svc_ecr_arn = module.ecr.chat_svc_ecr_arn
  chat_db_ecr_arn = module.ecr.chat_db_ecr_arn
  deployment_bucket_name = module.s3.deployment_bucket_name
}

module "security_groups" {
  source = "./modules/security-groups"
  project = var.project_name
  vpc_id = module.vpc.vpc_id
  http_port = var.http_port
  http_port_2 = var.http_port_2
  https_port = var.https_port
  ssh_port = var.ssh_port
  tcp_protocol = var.tcp_protocol
  ssh_protocol = var.ssh_protocol
  mysql_port = var.mysql_port
}

module "alb" {
  source = "./modules/alb"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  subnet_ids = [module.vpc.pub_subnet_1a_id, module.vpc.pub_subnet_2a_id]
  load_balancer_security_group_id = module.security_groups.load_balancer_sg_id
  http_port = var.http_port
  https_port = var.https_port
}

module "secrets_manager" {
  source = "./modules/secrets-manager"
  db_username = var.db_username
}

module "rds" {
  source = "./modules/rds"
  project_name = var.project_name
  db_username = var.db_username
  db_password = module.secrets_manager.db_password
  db_security_group_ids = [module.security_groups.db_server_sg_id]
  subnet_ids = [module.vpc.priv_subnet_1b_id, module.vpc.priv_subnet_2b_id]
}

module "ecr" {
  source = "./modules/ecr"
}