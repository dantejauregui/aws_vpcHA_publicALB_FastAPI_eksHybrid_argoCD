output "cluster_name" {
  value = aws_eks_cluster.fastApi_eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.fastApi_eks.endpoint
}

output "cluster_ca" {
  value = aws_eks_cluster.fastApi_eks.certificate_authority[0].data
}
