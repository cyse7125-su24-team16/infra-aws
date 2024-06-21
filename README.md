# infra-aws

## Infrastructure as Code with Terraform on Amazon Web Services for Kubernetes Cluster.

This repository contains Terraform configuration files for setting up networking resources on AWS. The objective is to create Kubernetes cluster along with their associated resources within the same organization and region.

### Prerequisites

- AWS Platform account
- Terraform installed on your local machine
- AWS command-line tool installed

### Steps:

#### 1. Install and Set Up gcloud CLI

Make sure you have the gcloud command-line tool installed and configured with the appropriate credentials.

```bash
aws configure --profile prod
aws configure list-profiles
```
