output "ecr_repository_url" {
  value       = aws_ecr_repository.app_repo.repository_url
  description = "URL ECR Repository vừa khởi tạo thành công"
}
