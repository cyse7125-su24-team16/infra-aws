variable "env" {
  description = "The infrastructure environment: dev/staging/prod."
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the infrastructure in."
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block subnet range"
  type        = string
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "public_subnets" {
  description = "List of public IPV4 subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private IPV4 subnets"
  type        = list(string)
}

variable "public_route_table_cidr_block" {
  description = "The CIDR block for the public route table."
  type        = string
}

variable "security_group_name" {
  type        = string
  description = "The name of the Security Group"
}

variable "https_ports" {
  description = "Ingress HTTPS ports"
  type        = string
}

variable "http_port" {
  description = "Ingress HTTP"
  type        = string
}

variable "egress_port" {
  description = "egress_port"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "nat_cidr_block" {
  description = "The CIDR block for the NAT Gateway"
  type        = string

}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "eks_secrets_encryption_description" {
  description = "Description for the KMS key used for EKS secrets encryption"
  type        = string
}

variable "eks_secrets_encryption_deletion_window_in_days" {
  description = "Deletion window in days for the KMS key used for EKS secrets encryption"
  type        = number
}

variable "ebs_volume_encryption_description" {
  description = "Description for the KMS key used for EBS volume encryption"
  type        = string
}

variable "ebs_volume_encryption_deletion_window_in_days" {
  description = "Deletion window in days for the KMS key used for EBS volume encryption"
  type        = number
}

variable "Eks_Worker_Node_Role_Name" {
  description = "The name of the IAM role for the EKS worker nodes"
  type        = string
}

variable "Eks_Cluster_Role_Name" {
  description = "The name of the IAM role for the EKS cluster"
  type        = string

}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "eks_authentication_mode" {
  type        = string
  description = "The authentication mode for the cluster"
}

variable "eks_ip_family" {
  type        = string
  description = "The IP family for the cluster"
}

variable "desired_size" {
  description = "The desired number of worker nodes"
  type        = number

}

variable "max_size" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "ami_type" {
  description = "The type of AMI to use for the worker nodes"
  type        = string
}

variable "node_group_capacity_type" {
  description = "The capacity type for the node group"
  type        = string
}

variable "max_unavailable" {
  description = "The maximum number of unavailable nodes during an update"
  type        = number
}

variable "disk_size" {
  description = "The disk size in GB for worker nodes"
  type        = number
}

variable "instance_types" {
  description = "The instance types for the worker nodes"
  type        = list(string)
}

variable "node_group_name" {
  description = "The name of the node group"
  type        = string
}

variable "cluster_enabled_log_types" {
  description = "The log types to enable for the EKS cluster"
  type        = list(string)

}

variable "eks_secrets_encryption_name" {
  description = "The name of the KMS key used for EKS secrets encryption"
  type        = string
}

variable "Ebs_Volume_Key_Name" {
  description = "The name of the KMS key used for EBS volume encryption"
  type        = string

}

variable "postgresql_namespace" {
  type        = string
  description = "The namespace in which the database is running"
}

variable "postgresql_release_name" {
  description = "The name of the Helm release"
  type        = string
}

variable "postgresql_chart_name" {
  description = "The name of the Helm chart"
  type        = string
}

variable "postgresql_chart_version" {
  description = "The version of the Helm chart"
  type        = string
}

variable "bitnami_repository_url" {
  description = "The URL of the repository where the PostgreSQL image is stored"
  type        = string
}

variable "kafka_chart_name" {
  description = "Name of the Kafka Helm chart to deploy"
  type        = string
}

variable "kafka_chart_version" {
  description = "Version of the Kafka Helm chart to use"
  type        = string
}

variable "kafka_namespace" {
  description = "Namespace where Kafka will be deployed"
  type        = string
}

variable "kafka_release_name" {
  description = "Name of the Kafka Helm release"
  type        = string
}

variable "chart_path" {
  description = "Path to the chart"
  type        = string
}

variable "kafka_values_file" {
  description = "Path to the values file for configuring Kafka deployment"
  type        = string
}

# variable "bitnami_repository_url" {
#   description = "URL of the Bitnami Helm chart repository"
#   type        = string
#   default     = "https://charts.bitnami.com/bitnami"
# }

# variable "postgresql_chart_name" {
#   description = "Name of the PostgreSQL Helm chart"
#   type        = string
#   default     = "postgresql-ha"
# }

# variable "postgresql_chart_version" {
#   description = "Version of the PostgreSQL Helm chart"
#   type        = string
#   default     = "14.2.7"
# }

variable "namespaces" {
  description = "The namespaces in which the producer and the conusmer role are getting created."
  type        = list(string)
}

variable "Autoscaler_Role_Name" {
  description = "The name of the IAM role to be used by the cluster autoscaler."
  type        = string
}

variable "resource_quota_cpu" {
  description = "A map defining CPU resource quotas for various namespaces. The map keys are namespace names, and the values are CPU quotas as strings."
  type        = map(string)
}

variable "resource_quota_memory" {
  description = "A map defining memory resource quotas for various namespaces. The map keys are namespace names, and the values are memory quotas as strings."
  type        = map(string)
}

variable "limit_range_default_cpu" {
  description = "A map defining default CPU limits for containers in various namespaces. The map keys are namespace names, and the values are default CPU limits as strings."
  type        = map(string)
}

variable "limit_range_default_memory" {
  description = "A map defining default memory limits for containers in various namespaces. The map keys are namespace names, and the values are default memory limits as strings."
  type        = map(string)
}

variable "limit_range_default_request_cpu" {
  description = "A map defining default CPU requests for containers in various namespaces. The map keys are namespace names, and the values are default CPU requests as strings."
  type        = map(string)
}

variable "limit_range_default_request_memory" {
  description = "A map defining default memory requests for containers in various namespaces. The map keys are namespace names, and the values are default memory requests as strings."
  type        = map(string)
}

variable "cluster_eks" {
  description = "Configuration for the EKS cluster"
  type        = map(any)
}

variable "ssh_algorithm" {
  description = "The algorithm to use for SSH key generation"
  type        = string
}

variable "ssh_rsa_bits" {
  description = "The number of bits to use for RSA key generation"
  type        = number
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "values_file" {
  description = "The path to the values file for the Helm chart"
  type        = string
}
