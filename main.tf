terraform {
  backend "local" {}
}

provider "aws" {
  version = "~> 2.60"
  region  = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.account}:role/OrganizationAccountAccessRole"
  }
}
