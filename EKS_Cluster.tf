module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # EKS Cluster Configuration
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  authentication_mode = var.eks_authentication_mode
  cluster_ip_family   = var.eks_ip_family

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Observability
  cluster_enabled_log_types = var.cluster_enabled_log_types

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
      most_recent = true
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
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}
