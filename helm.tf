# provider "helm" {
#   kubernetes {
#     host                   = var.cluster-name.endpoint
#     cluster_ca_certificate = base64decode(var.cluster-name.certificate_authority.0.data)
#     token                  = var.cluster-name.token
#     }
    
# }

# resource "helm_release" "ingress" {
#   name       = "ingress"
#   chart      = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   version    = "1.4.6"

#   set {
#     name  = "autoDiscoverAwsRegion"
#     value = "true"
#   }
#   set {
#     name  = "autoDiscoverAwsVpcID"
#     value = "true"
#   }
#   set {
#     name  = "clusterName"
#     value = var.cluster-name
#   }
# }

