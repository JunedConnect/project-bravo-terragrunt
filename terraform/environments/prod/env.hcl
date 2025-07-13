# The below 'locals' block is used accross the Terragrunt directory in places such as Helm, VPC, Root.hcl

locals {
  region = "eu-west-2"

  terraform-or-opentofu-version = ">= 1.10.1"

  provider-version = {
    aws        = "5.95.0"
    kubernetes = "2.36.0"
    helm       = "2.17.0"
  }

  default-tags = {
    Project   = "eks-terragrunt"
    Owner     = "juned"
    Terraform = "true"
  }
}