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
# terraform-docs

[![Build Status](https://github.com/terraform-docs/terraform-docs/workflows/ci/badge.svg)](https://github.com/terraform-docs/terraform-docs/actions) [![GoDoc](https://pkg.go.dev/badge/github.com/terraform-docs/terraform-docs)](https://pkg.go.dev/github.com/terraform-docs/terraform-docs) [![Go Report Card](https://goreportcard.com/badge/github.com/terraform-docs/terraform-docs)](https://goreportcard.com/report/github.com/terraform-docs/terraform-docs) [![Codecov Report](https://codecov.io/gh/terraform-docs/terraform-docs/branch/master/graph/badge.svg)](https://codecov.io/gh/terraform-docs/terraform-docs) [![License](https://img.shields.io/github/license/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/blob/master/LICENSE) [![Latest release](https://img.shields.io/github/v/release/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/releases)

![terraform-docs-teaser](./images/terraform-docs-teaser.png)

## What is terraform-docs

A utility to generate documentation from Terraform modules in various output formats.

## Installation

macOS users can install using [Homebrew]:

```bash
brew install terraform-docs
```

or

```bash
brew install terraform-docs/tap/terraform-docs
```

Windows users can install using [Scoop]:

```bash
scoop bucket add terraform-docs https://github.com/terraform-docs/scoop-bucket
scoop install terraform-docs
```

or [Chocolatey]:

```bash
choco install terraform-docs
```

Stable binaries are also available on the [releases] page. To install, download the
binary for your platform from "Assets" and place this into your `$PATH`:

```bash
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.18.0/terraform-docs-v0.18.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/terraform-docs
```
# Terraform Command Lines

### Format and Validate Terraform code
- ```terraform fmt``` #format code per HCL canonical standard
- ```terraform validate``` #validate code for syntax

### Initialize your Terraform working directory
- ```terraform init``` #initialize directory, pull down providers

### Plan, Deploy and Cleanup Infrastructure
- ```terraform apply --auto-approve``` #apply changes without being prompted to enter “yes”
- ```terraform destroy --auto-approve``` #destroy/cleanup deployment without being prompted for “yes”
- ```terraform plan -out plan.out``` #output the deployment plan to plan.out
- ```terraform apply plan.out``` #use the plan.out plan file to deploy infrastructure
- ```terraform plan -destroy``` #outputs a destroy plan
- ```terraform apply -target=aws_instance.my_ec2``` #only apply/deploy changes to the targeted resource
- ```terraform apply -var my_region_variable=us-east-1``` #pass a variable via command-line while applying a configuration
- ```terraform apply -lock=true``` #lock the state file so it can’t be modified by any other Terraform apply or modification action(possible only where backend allows locking)
- ```terraform apply refresh=false``` # do not reconcile state file with real-world resources(helpful with large complex deployments for saving deployment time)
- ```terraform apply --parallelism=5``` #number of simultaneous resource operations
- ```terraform refresh``` #reconcile the state in Terraform state file with real-world resources
- ```terraform providers``` #get information about providers used in current configuration
