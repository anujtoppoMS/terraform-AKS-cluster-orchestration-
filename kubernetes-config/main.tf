# Create namespaces
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

# resource "kubernetes_namespace" "ingress-nginx" {
#   metadata {
#     name = "ingress-nginx"
#   }
# }

# resource "kubernetes_service" "app_service" {
#   metadata {
#     name      = "app-service"
#     namespace = kubernetes_namespace.dev.metadata.0.name
#   }

#   spec {
#     selector = {
#       app = "my-app"
#     }

#     port {
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }

#     type = "NodePort"
#   }
# }

# resource "kubernetes_deployment" "app_deployment" {
#   metadata {
#     name      = "app-deployment"
#     namespace = kubernetes_namespace.dev.metadata.0.name
#   }

#   spec {
#     replicas = 2

#     selector {
#       match_labels = {
#         app = "my-app"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "my-app"
#         }
#       }

#       spec {
#         container {
#           name  = "my-app"
#           image = "nginx:latest"

#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }

#Install NGINX ingress controller
# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   namespace  = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"

#   set {
#     name  = "controller.service.loadBalancerIP"
#     value = "Auto" # Change to static IP if needed
#   }

#   set {
#     name  = "controller.service.annotations.service.beta.kubernetes.io/azure-load-balancer-internal"
#     value = "false"
#   }
# }

# resource "local_file" "kubeconfig" {
#   content  = var.kubeconfig
#   filename = "${path.root}/kubernetes-config/kubeconfig"
# }