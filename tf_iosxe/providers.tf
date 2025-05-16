terraform {
  required_providers {
    iosxe = {
      # The source needs to be provided since this isn't one of the "official" HashiCorp providers
      source = "CiscoDevNet/iosxe"
    }
  }
  cloud {
    organization = "tf-pawel-org"
    workspaces {
    # Different workspace per provider
      name = "tf-iosxe"
    }
  }
}

provider "iosxe" {
  # alias    = "ROUTER7"
  # username = var.LEGACY_USERNAME
  # password = var.LEGACY_PASSWORD
  username = "admin"
  password = "Cisco123"
  url      = "https://172.16.10.34"
}
