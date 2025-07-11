output "oidc-issuer-url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "eks-cluster-endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "eks-cluster-ca-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks-cluster-name" {
  value = aws_eks_cluster.this.name
}