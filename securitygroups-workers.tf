# workers
resource "aws_security_group" "demo-node-wrkgrp2" {
  name        = "terraform-eks-demo-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.K8s-vpc2.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group" "access-from-control-plane" {
  name        = "terraform-eks-demo-contol-plane"
  description = "Allow access from control plane to webhook port of AWS load balancer controller"
  vpc_id      = aws_vpc.K8s-vpc2.id

  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    # source_cluster_security_group = true
    
  }

  tags = {
    "Name"                                      = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "demo-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.demo-node-wrkgrp2.id
  source_security_group_id = aws_security_group.demo-node-wrkgrp2.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-node-wrkgrp2.id
  source_security_group_id = aws_security_group.demo-cluster-group.id
  to_port                  = 65535
  type                     = "ingress"
}
