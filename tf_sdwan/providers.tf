terraform {
  required_providers {
    sdwan = {
      source = "CiscoDevNet/sdwan"
    }
  }
  # Hashicorp recommends using the cloud block instead of the backend block (legacy)
  cloud {
    organization = "tf-pawel-org"
    # Different workspace per provider
    workspaces {
      name = "tf-sdwan"
    }
  }
}

# provider "sdwan" {
#   username = "${secrets.SDWAN_MANAGER_USERNAME}"
#   password = "${secrets.SDWAN_MANAGER_PASSWORD}"
#   url      = "https://10.12.0.20"
# }