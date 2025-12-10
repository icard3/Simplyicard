terraform {
  backend "s3" {
    bucket         = "simplyicard-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "simplyicard-terraform-locks"
  }
}
