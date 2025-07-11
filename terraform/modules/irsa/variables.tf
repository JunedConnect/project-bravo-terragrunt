variable "oidc-issuer-url" {
  description = "The OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "cert-manager-namespace" {
  description = "The namespace for cert-manager"
  type        = string
}

variable "external-dns-namespace" {
  description = "The namespace for external-dns"
  type        = string
}

variable "route53-zone-id" {
  description = "Route 53 hosted zone ID"
  type        = string
}