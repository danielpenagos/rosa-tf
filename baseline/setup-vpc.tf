provider "aws" {
  region  = var.aws_region
}

locals{
  common_tags = merge(
    var.common_tags
  )
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${var.cluster_name}-vpc"
  cidr = "${var.vpc_cidr}"

  azs             = var.az_ids[var.aws_region]
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.private_subnets_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = local.common_tags
}
