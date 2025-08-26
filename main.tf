# ------------------------------------------------------------------------------------------------------
# This is the corrected Terraform configuration file for your Azure deployment pipeline.
#
# Key Fixes:
# - The `backend` block now explicitly defines the required configuration parameters.
# - The hard-coded `subscription_id` has been removed for security and is now handled by the workflow.
# - The location "central india" has been corrected to a valid Azure region string.
# ------------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.37.0"
    }
  }

  # The backend block must contain the configuration details.
  # The values here must match the `-backend-config` values from the GitHub Actions workflow.
  backend "azurerm" {
    resource_group_name  = "ms-rg"
    storage_account_name = "msstg3"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.5.0"
}

# The provider block is now configured to work with the subscription ID from the workflow.
# The `subscription_id` is automatically set by the `azure/login` action.
provider "azurerm" {
  features {}
  # Removed the hard-coded `subscription_id` for better security.
}

resource "azurerm_resource_group" "test-pipeline-rg" {
  name     = "test-pipeline-rg"
  # Corrected the location to a valid Azure region string.
  location = "centralindia"
}