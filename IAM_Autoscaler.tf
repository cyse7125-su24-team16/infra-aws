locals {
  oidc_provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  account_id        = split(":", module.eks.cluster_arn)[4]
  oidc_provider_arn = "arn:aws:iam::${local.account_id}:oidc-provider/${local.oidc_provider_url}"
}

resource "aws_iam_role" "eks_cluster_autoscaler_role" {
  name = var.Autoscaler_Role_Name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = local.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })
}

# Define and attach an inline custom policy directly
resource "aws_iam_policy" "custom_eks_cluster_autoscaler_policy" {
  name        = var.Autoscaler_Policy_Name
  description = var.Autoscaler_Policy_Description
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_policy_attachment" {
  role       = aws_iam_role.eks_cluster_autoscaler_role.name
  policy_arn = aws_iam_policy.custom_eks_cluster_autoscaler_policy.arn
}
