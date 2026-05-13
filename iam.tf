# Get current IAM user
data "aws_caller_identity" "current" {}

data "aws_iam_user" "terraform_user" {
  user_name = "test-iac-admin"
}

# ECS Full Access
resource "aws_iam_user_policy_attachment" "ecs_full_access" {
  user       = data.aws_iam_user.terraform_user.user_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# VPC Full Access
resource "aws_iam_user_policy_attachment" "vpc_full_access" {
  user       = data.aws_iam_user.terraform_user.user_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}