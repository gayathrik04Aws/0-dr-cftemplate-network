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
data "terraform_remote_state" "networking" {
  backend = "remote"
  config = {
    organization = "eduphoria"
    workspaces = {
      name = "networking-dev"
    }
  }
}

data "terraform_remote_state" "security" {
  backend = "remote"
  config = {
    organization = "eduphoria"
    workspaces = {
      name = "security-dev"
    }
  }
}

data "terraform_remote_state" "database" {
  backend = "remote"
  config = {
    organization = "eduphoria"
    workspaces = {
      name = "database-dev"
    }
  }
}
