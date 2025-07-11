output "public-subnet-1-id" {
  description = "Public subnet 1 ID"
  value       = aws_subnet.publicsubnet1.id
}

output "public-subnet-2-id" {
  description = "Public subnet 2 ID"
  value       = aws_subnet.publicsubnet2.id
}

output "private-subnet-1-id" {
  description = "Private subnet 1 ID"
  value       = aws_subnet.privatesubnet1.id
}

output "private-subnet-2-id" {
  description = "Private subnet 2 ID"
  value       = aws_subnet.privatesubnet2.id
}
