terraform {
    source  = "../../../modules/eks"

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

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    public-subnet-1-id  = "subnet-11111111"
    public-subnet-2-id  = "subnet-22222222"
    private-subnet-1-id = "subnet-33333333"
    private-subnet-2-id = "subnet-44444444"
  }
  
  mock_outputs_allowed_terraform_commands = ["init","plan", "validate"]
}

inputs = {
  public-subnet-1-id  = dependency.vpc.outputs.public-subnet-1-id
  public-subnet-2-id  = dependency.vpc.outputs.public-subnet-2-id
  private-subnet-1-id = dependency.vpc.outputs.private-subnet-1-id
  private-subnet-2-id = dependency.vpc.outputs.private-subnet-2-id
}