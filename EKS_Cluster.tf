module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  authentication_mode = var.eks_authentication_mode
  cluster_ip_family   = var.eks_ip_family

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks_secrets_encryption.arn
  }

  iam_role_arn = aws_iam_role.Eks_Cluster_Role1.arn

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

  vpc_id                    = aws_vpc.VPC.id
  subnet_ids                = concat(aws_subnet.Public_Subnets[*].id, aws_subnet.Private_subnets[*].id)
  control_plane_subnet_ids  = aws_subnet.Private_subnets[*].id
  cluster_security_group_id = aws_security_group.EKS_Security_Group.id

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    aws_subnet.Public_Subnets,
    aws_security_group.EKS_Security_Group,
    aws_kms_key.eks_secrets_encryption
  ]

  eks_managed_node_groups = {
    eks_node_group = {
      name = var.node_group_name

      key_name = aws_key_pair.deployer.key_name

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      instance_types = var.instance_types
      ami_type       = var.ami_type
      capacity_type  = var.node_group_capacity_type
      disk_size      = var.disk_size

      iam_role_arn = aws_iam_role.Eks_Worker_Node_Role.arn

      subnet_ids = aws_subnet.Private_subnets[*].id

      update_config = {
        max_unavailable = var.max_unavailable
      }

      tags = {
        Name = var.node_group_name
      }

      depends_on = [
        aws_iam_role.Eks_Worker_Node_Role.arn,
      ]
    }
  }

  enable_cluster_creator_admin_permissions = true
}


data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}
