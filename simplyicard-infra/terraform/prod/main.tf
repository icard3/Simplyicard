module "vpc" {
  source = "../modules/vpc"

  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "rds" {
  source = "../modules/rds"

  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_username           = var.db_username
  db_password           = var.db_password
}

module "ecs" {
  source = "../modules/ecs"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.alb_security_group_id
  alb_id                = module.alb.alb_id
  container_image       = "${module.ecr.repository_urls["simplyicard-app"]}:latest"
  log_group_name        = "/ecs/prod-simplyicard-app"
  region                = "us-east-1"

  container_environment = [
    {
      name  = "DB_CONNECTION_STRING"
      value = "server=${element(split(":", module.rds.db_endpoint), 0)};port=${module.rds.db_port};database=simplyicard;user=${var.db_username};password=${var.db_password};"
    },
    {
      name  = "ASPNETCORE_URLS"
      value = "http://+:8080"
    }
  ]
}

module "alb" {
  source = "../modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  certificate_arn       = var.certificate_arn
}

module "ecr" {
  source = "../modules/ecr"

  repository_names = ["simplyicard-app"]
}

module "frontend" {
  source = "../modules/frontend"

  bucket_name  = "simplyicard-bookstore-frontend-prod"
  environment  = "prod"
  alb_dns_name = module.alb.alb_dns_name
}

module "sns" {
  source = "../modules/sns"
}

module "wireguard" {
  source          = "../modules/wireguard"
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_ids[0]
  vpc_cidr        = module.vpc.vpc_cidr
  num_clients     = 3
  alarm_topic_arn = module.sns.topic_arn
  enable_alarms   = true
}

module "securityhub" {
  source = "../modules/securityhub"
}

module "guardduty" {
  source          = "../modules/guardduty"
  alarm_topic_arn = module.sns.topic_arn
  enable_alarms   = true
}

module "cloudtrail" {
  source  = "../modules/cloudtrail"
  s3_bucket_name = "simplyicard-cloudtrail-logs-prod"
}

resource "aws_route53_zone" "private" {
  name = "dheera82s.online"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_record" "simplyicard" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "simplyicard.dheera82s.online"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

module "config" {
  source   = "../modules/config"
  alarm_topic_arn = module.sns.topic_arn
}

module "cloudwatch" {
  source          = "../modules/cloudwatch"
  env             = "prod"
  service_names   = ["simplyicard-app"]
  alarm_topic_arn = module.sns.topic_arn
  retention_days  = {
    "simplyicard-app" = 30
  }
}
