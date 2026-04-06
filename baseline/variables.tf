variable "aws_region" {
  type        = string
  description = "The region to create the ROSA cluster in"
  default     = "us-east-2"
  
  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1"], var.aws_region)
    error_message = "HyperShift is currently only availble in these regions: us-east-1, us-east-2, eu-west-1."
  }
}

variable "az_ids" {
  type        = object({
    us-east-1 = list(string)
    us-east-2 = list(string)
  })
  description = "A list of region-mapped AZ IDs that a subnet should get deployed into"
  default     = {
    us-east-1 = ["use1-az1","use1-az2","use1-az4"]
    us-east-2 = ["use2-az1","use2-az2","use2-az3"]
  }
}

variable "cluster_name" {
    type        = string
    description = "The name of the ROSA cluster to create"
    default     = "dpenagos-tf"
  
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]{0,13}[a-z0-9]$", var.cluster_name))
    error_message = "ROSA cluster name must be less than 16 characters, be lower case alphanumeric, with only hyphens."
  }
}

variable "common_tags" {
    type = map(string)
    default = {
      cost-center = "468"          # a required attribute
      service-phase = "lab"
      app-code = "MOBB-001"
      owner = "dpenagos_redhat.com"
      provisioner   = "Terraform"
    }

}
