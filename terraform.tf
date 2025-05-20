# Set up the provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
  required_version = ">= 1.1.0"
  cloud {
    organization = "anujtoppo_terraform_state"
    workspaces {
      name = "Dev"
    }
  }
  # backend "local" {
  #   path = "./state_files/state.tfstate"
  # }
}

provider "azurerm" {
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}