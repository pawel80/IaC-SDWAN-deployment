terraform {
  # required_providers {
  #   iosxe = {
  #     source = "CiscoDevNet/iosxe"
  #   }
  # }
  cloud {
    organization = "tf-pawel-org"
    workspaces {
    # Different workspace per provider
      name = "tf-iosxe"
    }
  }
}
