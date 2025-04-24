# Add restconf and aaa config to the router

provider "iosxe" {
  alias    = "ROUTER7"
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  url      = "https://172.16.10.34"
}

# provider "iosxe" {
#   alias    = "ROUTER8"
#   username = "${secrets.LEGACY_USERNAME}"
#   password = "${secrets.LEGACY_PASSWORD}"
#   url      = "https://172.16.10.38"
# }
