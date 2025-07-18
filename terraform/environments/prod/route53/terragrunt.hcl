terraform {
    source  = "../../../modules/route53"

    extra_arguments "tfvars" {
        commands = [
            "init",
            "plan",
            "apply",
            "destroy",
    ]
        required_var_files = [find_in_parent_folders("prod.tfvars")]
    }
}

include "root" {
    path = find_in_parent_folders("root.hcl")
}