terraform {
  required_version = ">= 1.2.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.39.0"
    }
  }
  backend "local" {
    path = "/tmp/terraform-acr.tfstate"
  }
}

provider "azurerm" {
  features {}
}
