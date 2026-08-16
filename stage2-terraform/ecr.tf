resource "aws_ecr_repository" "app_repo" {
  #checkov:skip=CKV_AWS_136:Lab environment uses default AWS managed encryption
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "DevSecOps"
    ManagedBy   = "Terraform"
  }
}
