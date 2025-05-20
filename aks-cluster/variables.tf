variable "kubernetes_version" {
  default = "1.31.1"
}

variable "workers_count" {
  default = "3"
}

variable "cluster_name" {
  default = "aks-k8s"
  type    = string
}

variable "rg_name" {
  default = "aks-rg"
  type    = string
}

variable "location" {
  default = "centralindia"
  type    = string
}