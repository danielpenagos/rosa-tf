aws_region="us-east-1"
cluster_name = "dpenagos-tf"
multi_az = true
with_localzone = true
cluster_is_already_created = false
cluster_infra_name = "dpenagos-rosa-45m2w"

vpc_cidr="10.0.0.0/16"
private_subnets_cidr_m_az=["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
private_subnets_cidr_s_az=["10.0.1.0/24"]
localzone_private_cidr="10.0.11.0/24"
localzone_public_cidr="10.0.12.0/24"

public_subnets_cidr_m_az=["10.0.101.0/24", "10.0.102.0/24","10.0.103.0/24"]
public_subnets_cidr_s_az=["10.0.101.0/24"]


common_tags = {
    cost-center = "468"          # a required attribute
    service-phase = "lab"
    app-code = "MOBB-001"
    owner = "dpenagos_redhat.com"
    provisioner   = "Terraform"
}