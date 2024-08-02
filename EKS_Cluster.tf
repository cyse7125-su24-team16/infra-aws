module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # EKS Cluster Configuration
  cluster_name                  = var.cluster_name
  cluster_version               = var.cluster_version
  authentication_mode           = var.eks_authentication_mode
  cluster_ip_family             = var.eks_ip_family
  create_cluster_security_group = false

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Observability
  cluster_enabled_log_types = ["api", "audit", "controllerManager", "scheduler"]

  # Encryption
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks_secrets_encryption.arn
  }

  # Identity and Access
  iam_role_arn = aws_iam_role.Eks_Cluster_Role.arn

  # Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = var.cluster_eks["cluster_addons"]["vpc-cni"]["most_recent"]
      configuration_values = jsonencode({
        enableNetworkPolicy = "true"
      })
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      most_recent              = true
    }
  }

  # Networking
  vpc_id                    = aws_vpc.VPC.id
  subnet_ids                = concat(aws_subnet.Public_Subnets[*].id, aws_subnet.Private_subnets[*].id)
  control_plane_subnet_ids  = aws_subnet.Private_subnets[*].id
  cluster_security_group_id = aws_security_group.EKS_Security_Group.id

  # Tags
  tags = {
    Name = var.cluster_name
  }

  # Explicit Dependencies for EKS Cluster
  depends_on = [
    aws_subnet.Public_Subnets,
    aws_security_group.EKS_Security_Group,
    aws_kms_key.eks_secrets_encryption
  ]

  eks_managed_node_groups = {
    eks_node_group = {
      name = var.node_group_name

      key_name = aws_key_pair.deployer.key_name

      # Scaling Configuration  
      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      # Node Configuration
      instance_types = var.instance_types
      ami_type       = var.ami_type
      capacity_type  = var.node_group_capacity_type
      disk_size      = var.disk_size

      # Node IAM Role
      iam_role_arn = aws_iam_role.Eks_Worker_Node_Role.arn

      # Node Group Networking
      subnet_ids = aws_subnet.Private_subnets[*].id

      # Optional: Set maximum unavailable nodes during updates
      update_config = {
        max_unavailable = var.max_unavailable
      }

      # Node Group Tags
      tags = {
        Name = var.node_group_name
      }

      # Explicit Dependencies for Node Group(s)
      depends_on = [
        aws_iam_role.Eks_Worker_Node_Role.arn,
      ]
    }
  }

  # Cluster access entry to add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  # Additional Security Group Rules
  node_security_group_additional_rules = {
    ingress_15017 = {
      description                   = var.EKS_ingress_15017_description
      protocol                      = var.EKS_ingress_15017_protocol
      from_port                     = var.EKS_ingress_15017_from_port
      to_port                       = var.EKS_ingress_15017_to_port
      type                          = var.EKS_ingress_15017_type
      source_cluster_security_group = true
    }
    ingress_15012 = {
      description                   = var.EKS_ingress_15012_description
      protocol                      = var.EKS_ingress_15012_protocol
      from_port                     = var.EKS_ingress_15012_from_port
      to_port                       = var.EKS_ingress_15012_to_port
      type                          = var.EKS_ingress_15012_type
      source_cluster_security_group = true
    }
  }
}

data "aws_eks_cluster" "cluster" {
  depends_on = [module.eks]
  name       = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "oidc_provider" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "oidc_issuer_arn" {
  value = data.aws_iam_openid_connect_provider.oidc_provider.arn
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_version" {
  value = module.eks.cluster_version
}

output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}

output "fluent_bit_role_arn" {
  value = aws_iam_role.fluent_bit.arn
}
