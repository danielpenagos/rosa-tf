provider "aws" {
  region = var.aws_region
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
# 1. El Bucket de S3 para el Estado
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}" # Nombre único global
  force_destroy = true

  tags = merge(var.bootstrap_tags, {
    Name = "Terraform Remote State Storage"
  })
  lifecycle {
    prevent_destroy = false # Protege el bucket de borrados accidentales
  }
}

# 2. Habilitar Versionamiento (Vital para recuperación)
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Cifrado del lado del servidor
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 4. Bloqueo de acceso público (Seguridad)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 5. Tabla de DynamoDB para el Bloqueo (Locking)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.bootstrap_tags, {
    Name = "Terraform State Locking Table"
  })
}