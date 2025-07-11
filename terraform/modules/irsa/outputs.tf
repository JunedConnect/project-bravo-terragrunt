output "cert-manager-irsa-role-arn" {
  value = aws_iam_role.cert-manager-irsa-role.arn
}

output "external-dns-irsa-role-arn" {
  value = aws_iam_role.external-dns-irsa-role.arn
}