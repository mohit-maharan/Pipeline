
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "ms-rg"
    storage_account_name = "msstg4"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.5.0"
}


provider "azurerm" {
  features {}
  # Removed the hard-coded `subscription_id` for better security.
}

resource "azurerm_resource_group" "test-pipeline-rg" {
  name     = "test-pipeline-rg"
  location = "centralindia"
}
