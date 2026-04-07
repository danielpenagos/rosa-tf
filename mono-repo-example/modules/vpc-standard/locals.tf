locals {
  # Lógica para nombres de recursos
  vpc_name = "${var.cluster_name}-network"
  # Combinar etiquetas fijas del equipo con las que vienen de cada stack
  full_tags = merge(
    var.common_tags,
    {
      "Terraform"   = "true"
      "Module"      = "vpc-standard"
      "LastUpdated" = timestamp()
    }
  )

  
}