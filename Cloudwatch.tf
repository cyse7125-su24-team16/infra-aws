resource "kubernetes_namespace" "amazon_cloudwatch" {
  metadata {
    name = var.cloud_watch_namespace
  }
}

resource "helm_release" "aws_for_fluent_bit" {
  name       = var.fluent_bit_name
  namespace  = var.cloud_watch_namespace
  repository = var.fluentbit_repository_url
  chart      = var.fluentbit_chart

  set {
    name  = "annotations.role_arn"
    value = aws_iam_role.fluent_bit.arn
  }
  set {
    name  = "image.repository"
    value = var.fluent_bit_image_repository
  }

  set {
    name  = "image.tag"
    value = var.fluent_bit_image_tag
  }

  set {
    name  = "image.pullPolicy"
    value = var.fluent_bit_image_pull_policy
  }

  set {
    name  = "rbac.pspEnabled"
    value = var.fluent_bit_rbac
  }

  set {
    name  = "service.extraService"
    value = var.fluent_bit_service
  }

  set {
    name  = "service.parsersFiles[0]"
    value = var.fluent_bit_parsers
  }

  set {
    name  = "input.enabled"
    value = var.fluent_bit_input_enabled
  }

  set {
    name  = "input.tag"
    value = var.fluent_bit_input_tag
  }

  set {
    name  = "input.path"
    value = var.fluent_bit_input_path
  }

  set {
    name  = "input.db"
    value = var.fluent_bit_input_db
  }

  set {
    name  = "input.memBufLimit"
    value = var.fluent_bit_input_memBufLimit
  }

  set {
    name  = "input.skipLongLines"
    value = var.fluent_bit_input_skipLongLines
  }

  set {
    name  = "input.refreshInterval"
    value = var.fluent_bit_input_refresh_interval
  }

  set {
    name  = "cloudWatchLogs.enabled"
    value = var.fluentbit_cloudwatch_logs_enabled
  }

  set {
    name  = "cloudWatchLogs.match"
    value = var.fluent_bit_cloudwatch_logs_match
  }

  set {
    name  = "cloudWatchLogs.region"
    value = var.region
  }

  set {
    name  = "cloudWatchLogs.logGroupName"
    value = var.fluent_bit_cloudwatch_logs_log_group_name
  }

  set {
    name  = "cloudWatchLogs.logStreamPrefix"
    value = "fluentbit-"
  }

  set {
    name  = "cloudWatchLogs.autoCreateGroup"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${var.account_id}:role/FluentBitRole-${var.cluster_name}-fluentbit"
  }

  set {
    name  = "serviceAccount.name"
    value = "fluent-bit"
  }
  set {
    name  = "daemonSet.volumes[0].name"
    value = "varlog"
  }
  set {
    name  = "daemonSet.volumes[0].hostPath.path"
    value = "/var/log"
  }
  set {
    name  = "daemonSet.volumes[1].name"
    value = "varlibdockercontainers"
  }
  set {
    name  = "daemonSet.volumes[1].hostPath.path"
    value = "/var/lib/docker/containers"
  }
  set {
    name  = "daemonSet.volumes[2].name"
    value = "fluent-bit-config"
  }
  set {
    name  = "daemonSet.volumes[2].configMap.name"
    value = "fluent-bit-config"
  }
  set {
    name  = "daemonSet.volumeMounts[0].name"
    value = "varlog"
  }
  set {
    name  = "daemonSet.volumeMounts[0].mountPath"
    value = "/var/log"
  }
  set {
    name  = "daemonSet.volumeMounts[1].name"
    value = "varlibdockercontainers"
  }
  set {
    name  = "daemonSet.volumeMounts[1].mountPath"
    value = "/var/lib/docker/containers"
  }
  set {
    name  = "daemonSet.volumeMounts[1].readOnly"
    value = "true"
  }
  set {
    name  = "daemonSet.volumeMounts[2].name"
    value = "fluent-bit-config"
  }
  set {
    name  = "daemonSet.volumeMounts[2].mountPath"
    value = "/fluent-bit/etc/"
  }
  set {
    name  = "daemonSet.volumeMounts[2].subPath"
    value = "fluent-bit.conf"
  }

  set {
    name  = "extraOutputs"
    value = "[OUTPUT]\n    Name cloudwatch_logs\n    Match *\n    region us-east-2\n    log_group_name /aws/eks/my-cluster/fluent-bit\n    log_stream_prefix from-fluent-bit-\n    auto_create_group true"
  }
}

# IAM role
locals {
  oidc_provider_url_without_https = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  aws_account_id                  = split(":", module.eks.cluster_arn)[4]
  oidc_provider_arn_new           = "arn:aws:iam::${local.aws_account_id}:oidc-provider/${local.oidc_provider_url_without_https}"
}

resource "aws_iam_policy" "fluent_bit_cloudwatch_policy" {
  name        = var.Fluent_bit_Policy_name
  description = var.Fluent_bit_policy_description
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "cloudwatch:PutMetricData",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role" "fluent_bit" {
  name = "FluentBitRole-${var.cluster_name}-fluentbit"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = local.oidc_provider_arn_new
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url_without_https}:sub" = "system:serviceaccount:amazon-cloudwatch:fluent-bit" # Line changed
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluent_bit_cloudwatch" {
  policy_arn = aws_iam_policy.fluent_bit_cloudwatch_policy.arn
  role       = aws_iam_role.fluent_bit.name
}
