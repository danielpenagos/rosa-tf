aws_region="us-east-1"
cluster_name = "dpenagos-tf"

vpc_cidr="10.0.0.0/16"
private_subnets_cidr=["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
public_subnets_cidr=["10.0.101.0/24", "10.0.102.0/24","10.0.103.0/24"]


common_tags = {
    cost-center = "468"          # a required attribute
    service-phase = "lab"
    app-code = "MOBB-001"
    owner = "dpenagos_redhat.com"
    provisioner   = "Terraform"
}