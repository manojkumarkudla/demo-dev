vpc_name     = "K8s-vpc2"
cluster-name = "terraform-eks-dev"
aws_region   = "eu-west-1"
vpc_cidr     = "192.168.0.0/16"
cidr_public_sub1  = "192.168.101.0/24"
cidr_public_sub2  = "192.168.102.0/24"
cidr_public_sub3  = "192.168.103.0/24"
cidr_private_sub1 = "192.168.1.0/24"
cidr_private_sub2 = "192.168.2.0/24"
cidr_private_sub3 = "192.168.3.0/24"

# cidr_data    = {
#     a = "192.168.3.0/24"
#     b = "192.168.4.0/24"
#     c = "192.168.5.0/24"
# }