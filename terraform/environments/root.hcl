locals {
  environment-variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region             = local.environment-variables.locals.region
  terraform-version  = local.environment-variables.locals.terraform-version
  provider-version   = local.environment-variables.locals.provider-version
  default-tags       = local.environment-variables.locals.default-tags
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "${local.terraform-version}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.provider-version.aws}"
    }
  }
}

provider "aws" {
  region = "${local.region}"
  default_tags {
    tags = {
      Project   = "${local.default-tags.Project}"
      Owner     = "${local.default-tags.Owner}"
      Terraform = "${local.default-tags.Terraform}"
    }
  }
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "tf-state-eks-project-bravo-terragrunt"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = "true"
    use_lockfile = true
  }
}
EOF
}