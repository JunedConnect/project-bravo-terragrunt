# General
name   = "juned-cluster"

# EKS
authentication-mode                         = "API"
bootstrap-cluster-creator-admin-permissions = true
cluster-version                             = "1.31"
endpoint-private-access                     = true
endpoint-public-access                      = true
upgrade_support_type                        = "STANDARD"
node-group-name                             = "eks-node-group"
desired-size                                = 1
max-size                                    = 2
min-size                                    = 1
instance-disk-size                          = 50
instance-types                              = ["t3.large"]
capacity-type                               = "ON_DEMAND"
eks-cluster-role-name                       = "eks-cluster-role"
eks-node-group-role-name                    = "eks-node-group-role"

# Helm
cert-manager-helm-name             = "cert-manager"
cert-manager-namespace             = "cert-manager"

external-dns-helm-name             = "external-dns"
external-dns-namespace             = "external-dns"

nginx-ingress-helm-name = "nginx-ingress"
nginx-ingress-namespace = "nginx-ingress"

argocd-helm-name             = "argocd"
argocd-namespace             = "argocd"

prom-graf-helm-name             = "prom-graf"
prom-graf-namespace             = "monitor"

# Route53
domain_name = "lab.juned.co.uk"

# VPC
vpc-cidr-block                 = "10.0.0.0/16"
publicsubnet1-cidr-block       = "10.0.1.0/24"
publicsubnet2-cidr-block       = "10.0.2.0/24"
privatesubnet1-cidr-block      = "10.0.3.0/24"
privatesubnet2-cidr-block      = "10.0.4.0/24"
enable-dns-support             = true
enable-dns-hostnames           = true
subnet-map-public-ip-on-launch = true
route-cidr-block               = "0.0.0.0/0"