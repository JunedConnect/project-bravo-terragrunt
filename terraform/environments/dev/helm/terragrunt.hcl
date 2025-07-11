terraform {
    source  = "../../../modules/helm"

    extra_arguments "tfvars" {
        commands = [
            "init",
            "plan",
            "apply",
            "destroy",
            "output",
    ]
        required_var_files = [find_in_parent_folders("dev.tfvars")]
    }
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

generate "provider-kubernetes-helm" {
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "${local.provider-version.kubernetes}"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "${local.provider-version.helm}"
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

provider "kubernetes" {
  host                   = var.eks-cluster-endpoint
  cluster_ca_certificate = base64decode(var.eks-cluster-ca-data)
  exec {
    api_version = "client.authentication.k8s.io/v1"
    args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks-cluster-endpoint
    cluster_ca_certificate = base64decode(var.eks-cluster-ca-data)
    exec {
      api_version = "client.authentication.k8s.io/v1"
      args        = ["eks", "get-token", "--cluster-name", var.eks-cluster-name]
      command     = "aws"
    }
  }
}
EOF
}

dependency "irsa" {
  config_path = "../irsa"

  mock_outputs = {
    cert-manager-irsa-role-arn = "arn:aws:iam::123456789012:role/cert-manager-role"
    external-dns-irsa-role-arn = "arn:aws:iam::123456789012:role/external-dns-role"
  }

  mock_outputs_allowed_terraform_commands = ["init","plan", "validate"]
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    eks-cluster-name = "mock-eks-cluster"
    eks-cluster-endpoint = "https://mock-eks-endpoint.eks.amazonaws.com"
    eks-cluster-ca-data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCkZha2UgQ2VydGlmaWNhdGUgQ29udGVudAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
  }

  mock_outputs_allowed_terraform_commands = ["init","plan", "validate"]
}

locals {
  helm_values_dir = "${get_terragrunt_dir()}/../../../helm-values"


  environment-variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region             = local.environment-variables.locals.region
  terraform-version  = local.environment-variables.locals.terraform-version
  provider-version   = local.environment-variables.locals.provider-version
  default-tags       = local.environment-variables.locals.default-tags
}

inputs = {
  cert-manager-irsa-role-arn  = dependency.irsa.outputs.cert-manager-irsa-role-arn
  external-dns-irsa-role-arn  = dependency.irsa.outputs.external-dns-irsa-role-arn
  eks-cluster-name            = dependency.eks.outputs.eks-cluster-name
  eks-cluster-endpoint        = dependency.eks.outputs.eks-cluster-endpoint
  eks-cluster-ca-data         = dependency.eks.outputs.eks-cluster-ca-data
  cert-manager-helm-values-file-path = "${local.helm_values_dir}/cert-manager.yml"
  external-dns-helm-values-file-path = "${local.helm_values_dir}/external-dns.yml"
  argocd-helm-values-file-path       = "${local.helm_values_dir}/argo-cd.yml"
  prom-graf-helm-values-file-path    = "${local.helm_values_dir}/prom-graf.yml"
}