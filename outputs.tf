output "kubeconfig" {
  value = abspath("${path.root}/kubernetes-config/kubeconfig")
}

output "cluster_name" {
  value = data.azurerm_kubernetes_cluster.aks_rg_k8s.name
}

output "kubeconfig1" {
  value = "${path.root}/kubeconfig"
}

output "kube_config_host" {
  value     = data.azurerm_kubernetes_cluster.aks_rg_k8s.kube_config.0.host
  sensitive = true
}

