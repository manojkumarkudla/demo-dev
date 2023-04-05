resource "aws_eks_cluster" "dev-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.dev-cluster-role.arn

  vpc_config {
    security_group_ids = [aws_security_group.demo-cluster-group.id]
    subnet_ids = [aws_subnet.public-sub3.id,aws_subnet.public-sub2.id,aws_subnet.public-sub1.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.dev-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.dev-cluster-AmazonEKSServicePolicy,
  ]
}
