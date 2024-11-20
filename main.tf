# Set up the provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "ccbb2c56-784e-481e-952d-87d364d657a9"
}

# Create a resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-rg"
  location = "centralindia"
}
# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-aks"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-k8s"
  kubernetes_version  = "1.31.1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# credential share
resource "null_resource" "get_credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_resource_group.aks_rg.name} --name ${azurerm_kubernetes_cluster.aks_cluster.name} --admin --overwrite-existing kubectl config use-context ${azurerm_kubernetes_cluster.aks_cluster.name}"
  }

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}
# kubernetes provider 

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create namespaces

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}

# Install NGINX ingress controller
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  set {
    name  = "controller.service.loadBalancerIP"
    value = "Auto" # Change to static IP if needed
  }

  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/azure-load-balancer-internal"
    value = "false"
  }
}

# Expose application using ingress
resource "kubernetes_ingress" "app_ingress" {
  metadata {
    name      = "app-ingress"
    namespace = "dev"
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "app-service"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = "dev"
  }

  spec {
    selector = {
      app = "my-app"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name      = "app-deployment"
    namespace = "dev"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}
