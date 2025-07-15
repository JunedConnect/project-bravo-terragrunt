terraform {
    source  = "../../../modules/irsa"

    extra_arguments "tfvars" {
        commands = [
            "init",
            "plan",
            "apply",
            "destroy",
    ]
        required_var_files = [find_in_parent_folders("dev.tfvars")]
    }
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    oidc-issuer-url = "https://oidc.eks.eu-west-1.amazonaws.com/id/EXAMPLEDATA"
  }

  mock_outputs_allowed_terraform_commands = ["init","plan", "validate"]
}

dependency "route53" {
  config_path = "../route53"

  mock_outputs = {
    route53-zone-id = "Z3P5QSUBK4POTI"
  }

  mock_outputs_allowed_terraform_commands = ["init","plan", "validate"]
}

inputs = {
  oidc-issuer-url  = dependency.eks.outputs.oidc-issuer-url
  route53-zone-id  = dependency.route53.outputs.route53-zone-id
}