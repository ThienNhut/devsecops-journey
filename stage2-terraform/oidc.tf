# 1. Tạo OIDC Provider cho GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub Actions OIDC Thumbprint
}

# 2. Tạo IAM Role cho GitHub Actions Runner
resource "aws_iam_role" "github_actions_ecr" {
  name = "github-actions-ecr-role"

  # Trust Policy: Chỉ cho phép Repo GitHub này AssumeRole
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            # BẮT BUỘC MATCH ĐÚNG REPO GITHUB CỦA ANH
            "token.actions.githubusercontent.com:sub" = "repo:ThienNhut/devsecops-journey:*"
          }
        }
      }
    ]
  })
}

# 3. Gắn quyền ECR cho Role
resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.github_actions_ecr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

# 4. Output ARN của Role để dùng trong GitHub Actions Workflow
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_ecr.arn
  description = "ARN of IAM Role for GitHub Actions OIDC"
}
