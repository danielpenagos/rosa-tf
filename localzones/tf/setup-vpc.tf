provider "aws" {
  region  = var.aws_region
}

locals{
  common_tags = merge(
    var.common_tags
  )
  private_subnets               = module.vpc.private_subnets
  public_subnets                = module.vpc.public_subnets
  vpc_id                        = module.vpc.vpc_id
  vpc_default_security_group_id = module.vpc.default_security_group_id
  vpc_arn                       = module.vpc.vpc_arn

  localzone_az     = element(data.aws_availability_zones.localzone.zone_ids, 0)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${var.cluster_name}-vpc"
  cidr = "${var.vpc_cidr}"

  azs             = var.multi_az ? var.az_ids_m_az[var.aws_region] : var.az_ids_s_az[var.aws_region]
  private_subnets = var.multi_az ? var.private_subnets_cidr_m_az : var.private_subnets_cidr_s_az
  public_subnets  = var.multi_az ? var.public_subnets_cidr_m_az : var.public_subnets_cidr_s_az

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge (local.common_tags,
    {"kubernetes.io/cluster/dpenagos-rosa-45m2w" = "owned"})
}

data "aws_availability_zones" "localzone" {
  all_availability_zones = true
#  exclude_zone_ids       = ["use1-bue1-az1", "use1-chi2-az1", "use1-dfw1-az1", "use1-iah1-az1", "use1-lim1-az1", "use1-scl1-az1","use1-qro1-az1","use1-mia2-az1"]
  exclude_zone_ids       = ["use1-chi2-az1", "use1-dfw1-az1", "use1-iah1-az1", "use1-lim1-az1", "use1-scl1-az1","use1-qro1-az1","use1-mia2-az1"]

  filter {
    name   = "opt-in-status"
    values = ["opted-in"]
  }
}

resource "aws_subnet" "localzone-private" {
  count             = var.with_localzone ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.localzone_private_cidr
  availability_zone = element(data.aws_availability_zones.localzone.names, 0)

  tags = merge(
#    local.common_tags, {
#    Name = "${var.cluster_name}-vpc-private-${local.localzone_az}",
#    "kubernetes.io/role/internal-elb"             = ""
#    })


    local.common_tags, {
    Name = "${var.cluster_name}-vpc-private-${local.localzone_az}",
    "kubernetes.io/role/internal-elb"             = "",
    "kubernetes.io/cluster/dpenagos-rosa-45m2w" = "shared"
    })

#   var.cluster_is_already_created ? ["kubernetes.io/cluster/dpenagos-cl-saz-qf6fp" = "shared"]}
#    map("kubernetes.io/cluster/dpenagos-cl-saz-qf6fp", "shared")
#    [var.cluster_is_already_created == true  ? {"kubernetes.io/cluster/dpenagos-cl-saz-qf6fp" = "shared"}: null]
#    [cluster_is_already_created ==true ? {"${var.cluster_infra_name}" = "shared"}:null]
#    "kubernetes.io/cluster/dpenagos-cl-saz-qf6fp" = "shared"
  
}



# The same route table as the first one, because there is no difference with that, due to the lack 
# of options to create NAT Gateway in the Local Zone. 
resource "aws_route_table_association" "private-lz" {
  count             = var.with_localzone ? 1 : 0
  subnet_id = aws_subnet.localzone-private[0].id
  route_table_id = module.vpc.private_route_table_ids[0]
}

resource "aws_subnet" "localzone-public" {
  count             = var.with_localzone ? 1 : 0
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.localzone_public_cidr
  availability_zone = element(data.aws_availability_zones.localzone.names, 0)

  tags = merge(
    local.common_tags, {
    "Name" = "${var.cluster_name}-vpc-public-${local.localzone_az}"
    "kubernetes.io/role/elb"             = ""},
  )
}

# The same route table as the first one, because there is no difference with that, due to the lack 
# of options to create NAT Gateway in the Local Zone. 
resource "aws_route_table_association" "public-lz" {
  count             = var.with_localzone ? 1 : 0
  subnet_id = aws_subnet.localzone-public[0].id
  route_table_id = module.vpc.public_route_table_ids[0]
}


