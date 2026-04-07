module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0" 

  name = local.vpc_name
  cidr = "${var.vpc_cidr}"

  azs             = var.az_ids[var.aws_region]
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = local.full_tags
}
