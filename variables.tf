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

variable "Cluster_Autoscaler_name" {
  description = "The name of the Autoscaler Helm Release"
  type        = string
}

variable "Autoscaler_namespace" {
  description = "The namespace in which the Autoscaler will be deployed"
  type        = string
}


variable "Autoscaler_chart_name" {
  description = "The name of the Autoscaler Helm chart"
  type        = string
}

variable "Autoscaler_values_file" {
  description = "The path to the values file for the Autoscaler deployment"
  type        = string
}

variable "Autoscaler_Policy_Name" {
  description = "The name of the IAM policy to be used by the cluster autoscaler."
  type        = string
}

variable "Autoscaler_Policy_Description" {
  description = "The ARN of the IAM policy to be used by the cluster autoscaler."
  type        = string
}

variable "Metrics_server_chart_name" {
  description = "The name of the metrics server Helm chart"
  type        = string
}

variable "Metrics_chart_repository" {
  description = "The URL of the repository where the metrics server image is stored"
  type        = string
}

variable "Metrics_server_chart_version" {
  description = "The version of the metrics server Helm chart"
  type        = string
}

variable "Resource_Quota_Name" {
  description = "The name of the Resource Quota for workload."
  type        = string
}

variable "Limit_Range_Name" {
  description = "The name of the Limit Range for workload."
  type        = string
}
variable "Metrics_Server_Name" {
  description = "The name of the Metrics Server Helm Release"
  type        = string
}

variable "Metrics_Chart_Name" {
  description = "The name of the Metrics Server Helm Chart"
  type        = string
}

variable "Metrics_Chart_version" {
  description = "The version of the Metrics Server Helm Chart"
  type        = string
}

variable "Metrics_Yaml_File" {
  description = "The path to the values file for the Metrics Server deployment"
  type        = string
}

variable "Postgresql_Yaml_File" {
  description = "The path to the values file for the Postgresql deployment"
  type        = string
}

variable "CRD_Name" {
  description = "The name of the CRD Helm Release"
  type        = string
}

variable "CRD_Namespace" {
  description = "The namespace in which the CRD will get created."
  type        = string
}

variable "CRD_chart_path" {
  description = "The path of the helm chart"
  type        = string
}

variable "CR_Name" {
  description = "The name of the CRD Helm Release"
  type        = string
}

variable "CR_chart_path" {
  description = "The path of the helm chart."
  type        = string
}

variable "storage_name" {
  description = "The name of the storage class"
  type        = string
}

# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = file("~/.ssh/id_rsa.pub")
# }

variable "Fluent_Bit_Role_Name" {
  description = "The name of the IAM role for Fluent Bit"
  type        = string
}

variable "account_id" {
  description = "AWS account id"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for Fluent Bit"
  type        = string
}

variable "image_repository" {
  description = "The image repository for Fluent Bit"
  type        = string
}

variable "image_tag" {
  description = "The image tag for Fluent Bit"
  type        = string
}

variable "image_pull_policy" {
  description = "The image pull policy for Fluent Bit"
  type        = string
}

variable "rbac_psp_enabled" {
  description = "Whether Pod Security Policies are enabled"
  type        = bool
}

variable "service_extra_service" {
  description = "Additional service configuration for Fluent Bit"
  type        = string
}

variable "service_parsers_files" {
  description = "Path to parsers files for Fluent Bit"
  type        = string
}

variable "input_enabled" {
  description = "Whether to enable the input plugin"
  type        = bool
}

variable "input_tag" {
  description = "The tag for Fluent Bit input"
  type        = string
}

variable "input_path" {
  description = "Path to the log files for Fluent Bit input"
  type        = string
}

variable "input_db" {
  description = "Path to the Fluent Bit database"
  type        = string
}

variable "input_mem_buf_limit" {
  description = "Memory buffer limit for Fluent Bit input"
  type        = string
}

variable "input_skip_long_lines" {
  description = "Whether to skip long lines in Fluent Bit input"
  type        = string
}

variable "fluent_bit_input_refresh_interval" {
  description = "Refresh interval for Fluent Bit input"
  type        = string
}

variable "fluentbit_cloudwatch_logs_enabled" {
  description = "Whether to enable CloudWatch Logs output"
  type        = bool
}

variable "fluent_bit_cloudwatch_logs_match" {
  description = "Match pattern for CloudWatch Logs"
  type        = string
}

variable "fluent_bit_cloudwatch_logs_log_group_name" {
  description = "Log group name for CloudWatch Logs"
  type        = string
}

variable "cloudwatch_logs_log_stream_prefix" {
  description = "Prefix for CloudWatch Logs log stream"
  type        = string
}

variable "cloudwatch_logs_auto_create_group" {
  description = "Whether to auto-create CloudWatch Logs log group"
  type        = bool
}

variable "service_account_create" {
  description = "Whether to create a service account"
  type        = bool
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "daemon_set_volumes" {
  description = "List of volumes for the DaemonSet"
  type = list(object({
    name            = string
    host_path_path  = string
    config_map_name = string
  }))
}

variable "daemon_set_volume_mounts" {
  description = "List of volume mounts for the DaemonSet"
  type = list(object({
    name       = string
    mount_path = string
    read_only  = bool
    sub_path   = string
  }))
}

variable "cloud_watch_namespace" {
  description = "The namespace for AWS Cloud Watch."
  type        = string
}

variable "fluent_bit_name" {
  description = "The name of the Fluent Bit Helm Release"
  type        = string
}

variable "fluentbit_repository_url" {
  description = "The URL of the repository where the Fluent Bit image is stored"
  type        = string
}

variable "fluentbit_chart" {
  description = "The name of the Fluent Bit Helm chart"
  type        = string
}

variable "fluent_bit_image_repository" {
  description = "The image repository for Fluent Bit"
  type        = string
}

variable "fluent_bit_image_tag" {
  description = "The image tag for Fluent Bit"
  type        = string
}

variable "fluent_bit_image_pull_policy" {
  description = "The image pull policy for Fluent Bit"
  type        = string
}

variable "fluent_bit_rbac" {
  description = "Whether RBAC is enabled for Fluent Bit"
  type        = string
}

variable "fluent_bit_service" {
  description = "The service configuration for Fluent Bit"
  type        = string
}

variable "fluent_bit_parsers" {
  description = "The parsers configuration for Fluent Bit"
  type        = string
}

variable "fluent_bit_input_enabled" {
  description = "Whether the input plugin is enabled for Fluent Bit"
  type        = bool
}

variable "fluent_bit_input_tag" {
  description = "The tag for the input plugin in Fluent Bit"
  type        = string
}

variable "fluent_bit_input_path" {
  description = "The path to the log files for the input plugin in Fluent Bit"
  type        = string
}

variable "fluent_bit_input_db" {
  description = "The path to the database for the input plugin in Fluent Bit"
  type        = string
}

variable "fluent_bit_input_memBufLimit" {
  description = "The memory buffer limit for the input plugin in Fluent Bit"
  type        = string
}

variable "fluent_bit_input_skipLongLines" {
  description = "Whether to skip long lines in the input plugin in Fluent Bit"
  type        = string
}

variable "Fluent_bit_Policy_name" {
  description = "The name of the IAM policy for Fluent Bit"
  type        = string
}

variable "Fluent_bit_policy_description" {
  description = "The description of the IAM policy for Fluent Bit"
  type        = string
}

variable "EKS_ingress_15017_description" {
  description = "The description of the ingress rule for port 15017"
  type        = string
}

variable "EKS_ingress_15017_protocol" {
  description = "The protocol for the ingress rule for port 15017"
  type        = string
}

variable "EKS_ingress_15017_from_port" {
  description = "The starting port for the ingress rule for port 15017"
  type        = number
}

variable "EKS_ingress_15017_to_port" {
  description = "The ending port for the ingress rule for port 15017"
  type        = number
}

variable "EKS_ingress_15017_type" {
  description = "The type of the ingress rule for port 15017"
  type        = string
}

variable "EKS_ingress_15012_description" {
  description = "The description of the ingress rule for port 15012"
  type        = string
}

variable "EKS_ingress_15012_protocol" {
  description = "The protocol for the ingress rule for port 15012"
  type        = string
}

variable "EKS_ingress_15012_from_port" {

  description = "The starting port for the ingress rule for port 15012"
  type        = number
}

variable "EKS_ingress_15012_to_port" {
  description = "The ending port for the ingress rule for port 15012"
  type        = number

}

variable "EKS_ingress_15012_type" {
  description = "The type of the ingress rule for port 15012"
  type        = string
}

variable "istio_namespace" {

  description = "The namespace in which Istio is deployed"
  type        = string
}

variable "isttio_base_name" {
  description = "The name of the Istio base Helm release"
  type        = string

}

variable "istio_repository" {
  description = "The URL of the repository where the Istio image is stored"
  type        = string

}

variable "istio_b_chart" {
  description = "The name of the Istio base Helm chart"
  type        = string

}

variable "istio_d_name" {
  description = "The name of the Istio deployment Helm release"
  type        = string
}

variable "istio_ingress_name" {
  description = "The name of the Istio ingress Helm release"
  type        = string

}

variable "Istio_ingress_chart" {
  description = "The name of the Istio ingress Helm chart"
  type        = string

}

variable "prometheus_name" {
  description = "The name of the Prometheus Helm release"
  type        = string

}

variable "prometheus_namespace" {
  description = "The namespace in which Prometheus is deployed"
  type        = string

}

variable "prometheus_repository" {
  description = "The URL of the repository where the Prometheus image is stored"
  type        = string

}
variable "prometheus_chart" {
  description = "The name of the Prometheus Helm chart"
  type        = string

}


