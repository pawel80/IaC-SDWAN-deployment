terraform {
  # required_providers {
  #   azurerm = {
  #     source  = "hashicorp/azurerm"
  #     # version = "~> 3.87.0"
  #   }
  # }
  required_providers {
    sdwan = {
      source = "CiscoDevNet/sdwan"
    }
  }

  # Hashicorp recommends using the cloud block instead of the backend block (legacy)
  cloud {
    organization = "tf-pawel-org"
    workspaces {
      name = "tf-sdwan"
    }
  }
}

provider "sdwan" {
  username = "${secrets.SDWAN_MANAGER_PASSWORD}"
  password = "${secrets.SDWAN_MANAGER_USERNAME}"
#  username = "${var.SDWAN_MANAGER_PASSWORD}"
#  password = "${var.SDWAN_MANAGER_USERNAME}"
  url      = "https://10.12.0.20"
}