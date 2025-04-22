terraform {
  # Hashicorp recommends using the cloud block instead of the backend block (legacy)
  cloud {
    organization = "tf-pawel-org"
    workspaces {
      name = "tf-sdwan"
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

# provider "sdwan" {
#   username = "${secrets.SDWAN_MANAGER_USERNAME}"
#   password = "${secrets.SDWAN_MANAGER_PASSWORD}"
#   url      = "https://10.12.0.20"
# }