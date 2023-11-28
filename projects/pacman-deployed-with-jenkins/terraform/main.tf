terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }

  required_version = ">= 1.3"
   backend "s3" {
     bucket = "terraform-state-test-my-cloud" # modify this to your bucket name
     key    = "pacman/terraform.tfstate" # modify this to your key name
     region = "us-east-1" # modify this to your region
   }
}

provider "aws" {
  region     = "us-east-1"
}