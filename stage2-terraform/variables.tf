variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS Region deploy hạ tầng"
}

variable "repo_name" {
  type        = string
  default     = "stage2-fastapi-tf"
  description = "Tên ECR Repository tạo bởi Terraform"
}
