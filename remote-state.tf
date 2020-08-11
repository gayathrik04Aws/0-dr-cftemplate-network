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
