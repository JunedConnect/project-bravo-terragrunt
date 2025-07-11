variable "name" {
  description = "Resource Name"
  type        = string
}

variable "authentication-mode" {
  description = "The authentication mode for the EKS cluster"
  type        = string
}

variable "bootstrap-cluster-creator-admin-permissions" {
  description = "Whether to grant bootstrap cluster creator admin permissions"
  type        = bool
}

variable "cluster-version" {
  description = "EKS cluster version"
  type        = string
}

variable "endpoint-private-access" {
  description = "Whether the EKS cluster API server is reachable from private endpoints"
  type        = bool
}

variable "endpoint-public-access" {
  description = "Whether the EKS cluster API server is reachable from public endpoints"
  type        = bool
}

variable "upgrade_support_type" {
  description = "The support type for the upgrade policy."
  type        = string
}

variable "node-group-name" {
  description = "The name of the EKS node group"
  type        = string
}

variable "desired-size" {
  description = "Desired number of nodes"
  type        = number
}

variable "max-size" {
  description = "Maximum number of nodes"
  type        = number
}

variable "min-size" {
  description = "Minimum number of nodes"
  type        = number
}

variable "instance-disk-size" {
  description = "Disk size for instances"
  type        = number
}

variable "instance-types" {
  description = "List of instance types to be used within the cluster"
  type        = list(string)
}

variable "capacity-type" {
  description = "Type of capacity for the EKS node group"
  type        = string
}

variable "eks-cluster-role-name" {
  description = "Name of the EKS cluster role"
  type        = string
}

variable "eks-node-group-role-name" {
  description = "Name of the EKS node group role"
  type        = string
}

variable "public-subnet-1-id" {
  description = "Public subnet 1 ID"
  type        = string
}

variable "public-subnet-2-id" {
  description = "Public subnet 2 ID"
  type        = string
}

variable "private-subnet-1-id" {
  description = "Private subnet 1 ID"
  type        = string
}

variable "private-subnet-2-id" {
  description = "Private subnet 2 ID"
  type        = string
}