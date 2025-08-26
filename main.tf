terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }

  backend "azurerm" {}

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  subscription_id = "f0c6c28a-7429-42b3-aefa-63439e20a651"
}

resource "azurerm_resource_group" "test-pipeline-rg" {
  name     = "test-pipeline-rg"
  location = "central india"
}

