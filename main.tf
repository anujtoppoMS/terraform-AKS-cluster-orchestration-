module "aks-cluster" {
  source       = "./aks-cluster"
  cluster_name = var.cluster_name
  location     = var.location
}

data "azurerm_kubernetes_cluster" "aks_rg_k8s" {
  depends_on          = [module.aks-cluster]
  name                = var.cluster_name
  resource_group_name = var.rg_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].host
  username               = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].username
  password               = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].host
    username               = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].username
    password               = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].password
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config[0].cluster_ca_certificate)
  }
}

module "kubernetes-config" {
  depends_on   = [module.aks-cluster]
  source       = "./kubernetes-config"
  cluster_name = var.cluster_name
  kubeconfig   = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config_raw

  providers = {
    kubernetes = kubernetes
  }
}