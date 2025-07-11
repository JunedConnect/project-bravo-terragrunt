terraform {
    source  = "../../../modules/vpc"

    extra_arguments "tfvars" {
        commands = [
            "init",
            "plan",
            "apply",
            "destroy",
            "output",
    ]
        required_var_files = [find_in_parent_folders("prod.tfvars")]
    }
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

locals {
  environment-variables = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region = local.environment-variables.locals.region

  azs = [
    "${local.region}a",
    "${local.region}b"
  ]
}

inputs = {
  availability-zone-1 = local.azs[0]
  availability-zone-2 = local.azs[1]
}