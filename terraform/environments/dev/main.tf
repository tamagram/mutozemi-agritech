terraform {
  cloud {
    organization = "tamadev"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      tags = ["agritech", "development"]
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
    }
  }
  profile = "tamadevelopment"
}
