module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true
  #   enable_cluster_proportional_autoscaler = true
  enable_karpenter                      = true
  enable_external_dns                   = true
  enable_cert_manager                   = true
  cert_manager_route53_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z041677423VHBCHX2BLES"]

  tags = {
    Environment = "dev"
  }
}


resource "aws_iam_policy" "cert_manager_policy" {
  name        = var.policyname
  description = var.policy_description
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53:GetChange",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ChangeResourceRecordSets"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "cert_manager_role" {
  name = var.cert_manager_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cert_manager_attach" {
  role       = aws_iam_role.cert_manager_role.name
  policy_arn = aws_iam_policy.cert_manager_policy.arn
}

# Associate the IAM role with the OIDC provider
resource "aws_iam_role_policy_attachment" "cert_manager_oidc" {
  role       = aws_iam_role.cert_manager_role.name
  policy_arn = aws_iam_policy.cert_manager_policy.arn
}


resource "aws_iam_role" "cert_manager_assume_role" {
  name               = var.cert_manager_assume_role_name
  assume_role_policy = data.aws_iam_policy_document.cert_manager_assume_role.json
}
data "aws_iam_policy_document" "cert_manager_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.oidc_provider.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.oidc_provider.url}:sub"
      values   = ["system:serviceaccount:cert-manager:cert-manager"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "cert_manager_attach1" {
  role       = aws_iam_role.cert_manager_assume_role.name
  policy_arn = aws_iam_policy.cert_manager_policy.arn
}
