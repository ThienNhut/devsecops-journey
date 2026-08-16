# 1. Tạo OIDC Provider cho GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a218d500609a31a155554f6769992f0263f5"
  ]
}

# 2. Tạo IAM Role cho GitHub Actions Runner
resource "aws_iam_role" "github_actions_ecr" {
  name = "github-actions-ecr-role"

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
            # Nới rộng để test xem OIDC có bắt tay thành công không
            "token.actions.githubusercontent.com:sub" = "repo:*:*"
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

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_ecr.arn
  description = "ARN of IAM Role for GitHub Actions OIDC"
}
