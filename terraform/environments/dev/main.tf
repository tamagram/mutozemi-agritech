terraform {
  backend "remote" {
    organization = "tamadev"
    workspaces {
      name = "agritech"
    }
  }


  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source = "hashicorp/archive"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["./credentials"]
  profile                  = "tamadevelopment"
  region                   = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
    }
  }
}

module "rest_api" {
  source        = "./modules/api_gateway"
  s3_bucket_arn = module.grow_s3.bucket_arn
}

module "grow_s3" {
  source = "./modules/s3"
}
