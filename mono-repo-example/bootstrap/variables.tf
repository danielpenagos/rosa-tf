variable "bootstrap_tags" {
  type        = map(string)
  description = "Tags básicos para la infraestructura de estado"
  default     = {
    cost-center = "CC468"          # a required attribute
    service-phase = "lab"
    app-code = "MOBB-001"
    owner = "dpenagos_redhat.com"
    provisioner   = "Terraform"
  }
}

variable "bucket_prefix" {
  type        = string
  description = "Bucket's name"
  default     = "dpenagos-s3"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Dynamo DB Table Name"
  default     = "terraform-running-locks"
}

variable "aws_region" {
  type        = string
  description = "The region to create the ROSA cluster in"
  default     = "us-east-1"
  
  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-west-1"], var.aws_region)
    error_message = "HyperShift is currently only availble in these regions: us-east-1, us-east-2, eu-west-1."
  }
}