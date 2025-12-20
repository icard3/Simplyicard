module "vpc" {
  source = "../modules/vpc"

  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "rds" {
  source = "../modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
}

module "ecs" {
  source = "../modules/ecs"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
}

module "alb" {
  source = "../modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecr" {
  source = "../modules/ecr"

  repository_names = ["simplyicard-app"]
}

module "securityhub" {
  source = "../modules/securityhub"
}

module "guardduty" {
  source = "../modules/guardduty"
}

module "cloudtrail" {
  source = "../modules/cloudtrail"
  s3_bucket_name = "simplyicard-cloudtrail-logs-prod"
}

module "config" {
  source = "../modules/config"
  config_bucket_name = "simplyricard-config-logs-prod"
}
