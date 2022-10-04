provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::405079206131:role/dm-eu-west-2-dev-iam"
  }
}

terraform {
  backend "s3" {
    bucket = "devops-eu-west-2"
    key    = "terraform/backend/nonprod/dm/eu-west-2/dev/terraform.tfstate"
    region = "eu-west-2"
  }
}

