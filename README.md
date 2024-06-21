# infra-aws:
# Elastic Kubernetes Service

Set up a managed kubernetes cluster on AWS (EKS) using Hashicorp Terraform Infrastructure as Code tool.


## Working with Terraform

> \[!IMPORTANT]\
> Please note that you will need to configure the `AWS_PROFILE` environment variable to match your specified local AWS CLI profile in order to successfully deploy the infrastructure on AWS.
> You can do so by running `export AWS_PROFILE=<profile-name>` to set the variable locally on your terminal.

- Initialize Terraform

  ```bash
  terraform init
  ```

- Plan the infrastructure installation

  ```bash
  terraform plan -var-file="prod.tfvars"
  ```

- Apply the infrastructure changes

  ```bash
  terraform apply --auto-approve -var-file="prod.tfvars"
  ```

