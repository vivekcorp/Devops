terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "VKT_RG"
      storage_account_name = "vivekstorage24"
      container_name       = "vivek"
      key                  = "terraform.tfstate"
  }
}
