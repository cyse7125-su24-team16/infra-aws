resource "aws_kms_key" "eks_secrets_encryption" {
  description             = var.eks_secrets_encryption_description
  deletion_window_in_days = var.eks_secrets_encryption_deletion_window_in_days

  tags = {
    Name = "${var.cluster_name}-eks-secrets-encryption"
  }
}

resource "aws_kms_alias" "eks_secrets_encryption_alias" {
  name          = var.eks_secrets_encryption_name
  target_key_id = aws_kms_key.eks_secrets_encryption.key_id
}


resource "aws_kms_key" "ebs_volume_encryption" {
  description             = var.ebs_volume_encryption_description
  deletion_window_in_days = var.ebs_volume_encryption_deletion_window_in_days

  tags = {
    Name = "${var.cluster_name}-ebs-volume-encryption"
  }
}

resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = var.storage_name
    # annotations = {
    #   "storageclass.kubernetes.io/is-default-class" = "true"
    # }
  }
  storage_provisioner = "ebs.csi.aws.com"
  parameters = {
    type      = "gp2"
    encrypted = "true"
    kmsKeyId  = aws_kms_key.ebs_volume_encryption.arn
  }
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}
