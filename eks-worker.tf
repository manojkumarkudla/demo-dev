# data "aws_ami" "eks-worker" {
#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-${aws_eks_cluster.demo-cluster.version}-v*"]
#   }

#   most_recent = true
#   owners      = ["602401143452"] # Amazon
# }

# # EKS currently documents this required userdata for EKS worker nodes to
# # properly configure Kubernetes applications on the EC2 instance.
# # We utilize a Terraform local here to simplify Base64 encoding this
# # information into the AutoScaling Launch Configuration.
# # More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
# locals {
#   demo-node-userdata = <<USERDATA
# #!/bin/bash
# set -o xtrace
# /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.demo-cluster.certificate_authority[0].data}' '${var.cluster-name}'
# USERDATA

# }

# resource "aws_launch_configuration" "demo" {
#   associate_public_ip_address = true
#   iam_instance_profile = aws_iam_instance_profile.demo-node.name
#   image_id = data.aws_ami.eks-worker.id
#   instance_type = "t2.medium"
#   name_prefix = "terraform-eks-demo"
#   security_groups = [aws_security_group.demo-node-wrkgrp.id]
#   user_data_base64 = base64encode(local.demo-node-userdata)

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "demo" {
#   desired_capacity = 2
#   launch_configuration = aws_launch_configuration.demo.id
#   max_size = 5
#   min_size = 2
#   name = "terraform-eks-demo"

#   vpc_zone_identifier = [aws_subnet.public-sub3.id,aws_subnet.public-sub2.id,aws_subnet.public-sub1.id]

#   tag {
#     key = "Name"
#     value = "terraform-eks-demo"
#     propagate_at_launch = true
#   }

#   tag {
#     key = "kubernetes.io/cluster/${var.cluster-name}"
#     value = "owned"
#     propagate_at_launch = true
#   }
# }




#--------------------------
# worker node group
#--------------------------

 resource "aws_eks_node_group" "worker-node-group2" {
  cluster_name  = aws_eks_cluster.dev-cluster.name
  node_group_name = "dev-workernodes"
  node_role_arn  = aws_iam_role.dev-node.arn
  subnet_ids   = [aws_subnet.public-sub1.id,aws_subnet.public-sub2.id,aws_subnet.public-sub3.id]
  instance_types = ["t3.medium"]
#   source_security_group_ids = [aws_security_group.access-from-control-plane.id]
 
  scaling_config {
   desired_size = 2
   max_size   = 4
   min_size   = 1
  }

# #   node_security_group_additional_rules = {
#     ingress_allow_access_from_control_plane = {
#       type                          = "ingress"
#       protocol                      = "tcp"
#       from_port                     = 9443
#       to_port                       = 9443
#       source_cluster_security_group = true
#       description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
#     }
# #  }
 
 
  depends_on = [
   aws_iam_role_policy_attachment.dev-node-AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.dev-node-AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
  ]
 }

  






