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
  alias    = "ROUTER1"
  username = "admin"
  password = "password"
  url      = "https://10.1.1.1"
}

provider "iosxe" {
  alias    = "ROUTER2"
  username = "admin"
  password = "password"
  url      = "https://10.1.1.2"
}

# provider "sdwan" {
#   username = "${secrets.SDWAN_MANAGER_USERNAME}"
#   password = "${secrets.SDWAN_MANAGER_PASSWORD}"
#   url      = "https://10.12.0.20"
# }