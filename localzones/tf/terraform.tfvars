aws_region="us-east-1"
cluster_name = "dpenagos-tf"
multi_az = true
with_localzone = true
cluster_is_already_created = true
cluster_infra_name = "dpenagos-rosa-45m2w"

vpc_cidr="10.0.0.0/16"
common_tags = {
    cost-center = "CC468"          # a required attribute
    service-phase = "lab"
    app-code = "MOBB-001"
    owner = "dpenagos_redhat.com"
    provisioner   = "Terraform"
}