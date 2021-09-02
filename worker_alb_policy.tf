resource "aws_iam_policy" "alb_policy" {
  name        = "gh-${var.environment}-alb-policy"
  path        = "/"
  description = "Policy for EKS ALB"

  policy = file("${path.module}/policies/alb-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_role_att" {
  policy_arn = aws_iam_policy.alb_policy.arn
  role       = module.gh-eks-cluster.worker_iam_role_name
}

