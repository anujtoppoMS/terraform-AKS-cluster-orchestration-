variable "location" {
  type    = string
  default = "centralindia"
}

variable "cluster_name" {
  default = "aks-k8s"
}

variable "rg_name" {
  default = "aks-rg"
  type    = string
}

# variable "client_id" {
#   type = string
# }
# variable "client_secret" {
#   type = string
# }
# variable "tenant_id" {
#   type = string
# }
variable "subscription_id" {
  type = string
  default = "6c5ab08a-38e2-49b5-a0f0-b7c78bbbea6d"
}
