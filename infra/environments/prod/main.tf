module "network" {
  source = "../../modules/network"

  project_name = "tripire"
  environment  = var.environment

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}

module "security" {
  source = "../../modules/security"

  project_name = "tripire"
  environment  = var.environment

  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "../../modules/alb"

  project_name = "tripire"
  environment  = var.environment

  vpc_id = module.network.vpc_id

  public_subnet_ids = module.network.public_subnet_ids

  alb_security_group_id = module.security.alb_security_group_id
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = "tripire"
  environment  = var.environment

  private_subnet_ids = module.network.private_subnet_ids

  ecs_security_group_id = module.security.ecs_security_group_id

  target_group_arn = module.alb.target_group_arn
}

module "rds" {
  source = "../../modules/rds"

  project_name = "tripire"
  environment  = var.environment

  private_subnet_ids = module.network.private_subnet_ids

  rds_security_group_id = module.security.rds_security_group_id

  db_instance_class = var.db_instance_class

  db_allocated_storage = var.db_allocated_storage

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection

  db_password = var.db_password

}

