variable "aws_region" {
  type        = string
  description = "The region to create the ROSA cluster in"
  default     = "us-east-1"
  
  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1"], var.aws_region)
    error_message = "HyperShift is currently only availble in these regions: us-east-1, us-east-2, eu-west-1."
  }
}

variable "az_ids_m_az" {
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

variable "az_ids_s_az" {
  type        = object({
    us-east-1 = list(string)
    us-east-2 = list(string)
  })
  description = "A list of region-mapped AZ IDs that a subnet should get deployed into"
  default     = {
    us-east-1 = ["use1-az1"]
    us-east-2 = ["use2-az1"]
  }
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr for the vpc"
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr_m_az" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
}

variable "private_subnets_cidr_s_az" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_subnets_cidr_s_az" {
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

variable "public_subnets_cidr_m_az" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24","10.0.103.0/24"]
}

variable "with_localzone" {
  type        = bool
  description = "Indicates if the deployment will have a subnet located in a local zone"
  default     = false
}

variable "localzone_private_cidr" {
  type        = string
  default     = "10.0.11.0/24"
}

variable "localzone_public_cidr" {
  type        = string
  default     = "10.0.12.0/24"
}



variable "multi_az" {
  type        = bool
  description = "Declares wheather the cluster would be single az or multi az"
  default     = false
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
      cost-center = "CC468"          # a required attribute
      service-phase = "lab"
      app-code = "MOBB-001"
      owner = "dpenagos_redhat.com"
      provisioner   = "Terraform"
    }

}

variable "cluster_is_already_created" {
    type           = bool
    default        = false
    description    = "flag to apply tags to vpc and private subnet only when the cluster is created"
}

variable "cluster_infra_name" {
    type           = string
    description    = "Name of the infra that appears in the rosa description cluster. It should include the prefix kubernetes.io/cluster/. E.g: kubernetes.io/cluster/dpenagos-cl-saz-t866f"
}
