variable "cert-manager-helm-name" {
  description = "The name of the Helm release for cert-manager"
  type        = string
}

variable "cert-manager-helm-values-file-path" {
  description = "The file path to the cert-manager Helm values"
  type        = string
}

variable "cert-manager-namespace" {
  description = "The namespace for cert-manager"
  type        = string
}

variable "external-dns-helm-name" {
  description = "The name of the Helm release for external-dns"
  type        = string
}

variable "external-dns-helm-values-file-path" {
  description = "The file path to the external-dns Helm values"
  type        = string
}

variable "external-dns-namespace" {
  description = "The namespace for external-dns"
  type        = string
}

variable "nginx-ingress-helm-name" {
  description = "The name of the Helm release for nginx-ingress"
  type        = string
}

variable "nginx-ingress-namespace" {
  description = "The namespace for nginx-ingress"
  type        = string
}

variable "argocd-helm-name" {
  description = "The name of the Helm release for argocd"
  type        = string
}

variable "argocd-helm-values-file-path" {
  description = "The file path to the argocd Helm values"
  type        = string
}

variable "argocd-namespace" {
  description = "The namespace for nginx-ingress"
  type        = string
}

variable "prom-graf-helm-name" {
  description = "The name of the Helm release for argocd"
  type        = string
}

variable "prom-graf-helm-values-file-path" {
  description = "The file path to the prom-graf Helm values"
  type        = string
}

variable "prom-graf-namespace" {
  description = "The namespace for prom-graf"
  type        = string
}

variable "cert-manager-irsa-role-arn" {
  description = "IAM role ARN for cert-manager IRSA"
  type        = string
}

variable "external-dns-irsa-role-arn" {
  description = "IAM role ARN for external-dns IRSA"
  type        = string
}

# the below variables were added in as extra in order to get Terragrunt to recognise the variable and use it within the Kubernetes/Helm Provider block

variable "eks-cluster-name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks-cluster-endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "eks-cluster-ca-data" {
  description = "EKS cluster CA data"
  type        = string
}