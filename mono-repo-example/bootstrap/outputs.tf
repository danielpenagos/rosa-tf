output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "El ARN del bucket de S3 para el estado"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "Copia este nombre para el campo 'bucket' en tu backend"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Copia este nombre para el campo 'dynamodb_table' en tu backend"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.terraform_locks.arn
  description = "El ARN de la tabla de DynamoDB utilizada para el bloqueo de estado"
}

output "aws_region" {
  value       = "us-east-1"
  description = "La región donde se creó la infraestructura de estado"
}

output "terraform_backend_config_example" {
  value = <<EOF
  terraform {
    backend "s3" {
      bucket         = "${aws_s3_bucket.terraform_state.id}"
      key            = "CAMBIAR_POR_RUTA_DEL_STACK/terraform.tfstate"
      region         = "us-east-1"
      dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
      encrypt        = true
    }
  }
  EOF
  description = "Ejemplo listo para copiar y pegar en tus stacks"
}