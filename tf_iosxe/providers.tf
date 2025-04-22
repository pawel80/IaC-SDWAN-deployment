terraform {
  required_providers {
    iosxe = {
      source = "CiscoDevNet/iosxe"
    }
  }
  cloud {
    organization = "tf-pawel-org"
    workspaces {
      name = "tf-iosxe"
    }
  }
}

provider "iosxe" {
  alias    = "ROUTER7"
  username = "${secrets.LEGACY_USERNAME}"
  password = "${secrets.LEGACY_PASSWORD}"
  url      = "https://172.16.10.34"
}

provider "iosxe" {
  alias    = "ROUTER8"
  username = "${secrets.LEGACY_USERNAME}"
  password = "${secrets.LEGACY_PASSWORD}"
  url      = "https://172.16.10.38"
}
