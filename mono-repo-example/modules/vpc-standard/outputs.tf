output "cluster-id" {
  value = module.vpc.vpc_id
}

output "cluster-private-subnet" {
  value = module.vpc.private_subnets
}

output "cluster-public-subnet" {
  value = module.vpc.public_subnets
}
