provider "aws" {
  region = var.aws_region
}

terraform {
    backend "s3" {
      bucket         = "dpenagos-s3-tf-769d07f6"
      key            = "environment-1/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "dpenagos-tf-running-locks"
      encrypt        = true
    }
}

module "mi_red" {
  source = "../../modules/vpc-standard"

  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  aws_region           = var.aws_region
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  common_tags          = var.common_tags
}