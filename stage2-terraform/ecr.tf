resource "aws_ecr_repository" "app_repo" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE" # Chống ghi đè Tag

  image_scanning_configuration {
    scan_on_push = true # Tự động quét CVEs khi push Image
  }

  tags = {
    Environment = "DevSecOps"
    ManagedBy   = "Terraform"
  }
}
