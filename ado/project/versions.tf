terraform {
  required_version = ">= 1.0, <= 1.5.7"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.10.0"
    }
  }
}