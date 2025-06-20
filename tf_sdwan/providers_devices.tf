terraform {
  required_providers {
    sdwan = {
      source = "CiscoDevNet/sdwan"
    }
  }
  # Hashicorp recommends using the cloud block instead of the backend block (legacy)
  cloud {
    organization = "tf-pawel-org"
    workspaces {
    # Different workspace per provider
      name = "tf-sdwan"
    }
  }
}

# provider "sdwan" {
#   username = "${secrets.SDWAN_MANAGER_USERNAME}"
#   password = "${secrets.SDWAN_MANAGER_PASSWORD}"
#   url      = "https://10.12.0.20"
# }

locals {
sd-wan_edges = [
    {
    id     = "C8K-0004C57D-A2B1-4D3D-8F7A-ABA9D3AF1D8D"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "S1R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 101
      },
      {
        name = "system_ip"
        value = "11.1.1.1"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      {
        name = "var_def_gtw"
        value = "172.16.10.1"
      },
      {
        name = "var_vpn0_gig1_if_address"
        value = "172.16.10.2"
      },
      {
        name = "var_vpn0_gig1_if_mask"
        value = "255.255.255.252"
      }
      # {
      #   name = "var_dns_secondary"
      #   value = "1.2.3.4"
      # }
      # {
      #   name = "var_tunnel_netconf"
      #   value = true
      # }
      ]
    },
    {
    id     = "C8K-55121EB3-198F-3F17-2F1C-5D73078DBEE0"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "S2R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 102
      },
      {
        name = "system_ip"
        value = "11.1.2.1"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      {
        name = "var_def_gtw"
        value = "172.16.10.9"
      },
      {
        name = "var_vpn0_gig1_if_address"
        value = "172.16.10.10"
      },
      {
        name = "var_vpn0_gig1_if_mask"
        value = "255.255.255.252"
      }
      ]
    }
  ]

  sd-wan_cores = [
    {
    id     = "C8K-0B056B18-8343-6571-EB92-3DB657535324"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "DC1R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 901
      },
      {
        name = "system_ip"
        value = "99.9.1.1"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      {
        name = "var_def_gtw"
        value = "172.16.99.1"
      },
      {
        name = "var_vpn0_gig1_if_address"
        value = "172.16.99.2"
      },
      {
        name = "var_vpn0_gig1_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_vpn511_gig2_511_if_address"
        value = "172.16.51.1"
      },
      {
        name = "var_vpn511_gig2_511_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.10.1"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      }
      ]
    },
    {
    id     = "C8K-19B2B9DC-8320-438F-7F7A-0A570B80963E"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "DC2R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 902
      },
      {
        name = "system_ip"
        value = "99.9.1.2"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      {
        name = "var_def_gtw"
        value = "172.16.99.5"
      },
      {
        name = "var_vpn0_gig1_if_address"
        value = "172.16.99.6"
      },
      {
        name = "var_vpn0_gig1_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_vpn511_gig2_511_if_address"
        value = "172.16.51.5"
      },
      {
        name = "var_vpn511_gig2_511_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.20.1"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      }
      ]
    },
    {
    id     = "C8K-3CD1F9E6-37A0-7FC9-9B56-F39B676A0082"
    deploy = true
    variables = [
      {
        name = "host_name"
        value = "DC3R1"
      },
      {
        name = "pseudo_commit_timer"
        value = 0
      },
      {
        name = "site_id"
        value = 903
      },
      {
        name = "system_ip"
        value = "99.9.1.3"
      },
      {
        name = "ipv6_strict_control"
        value = "false"
      },
      {
        name = "var_def_gtw"
        value = "172.16.99.9"
      },
      {
        name = "var_vpn0_gig1_if_address"
        value = "172.16.99.10"
      },
      {
        name = "var_vpn0_gig1_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_vpn511_gig2_511_if_address"
        value = "172.16.51.9"
      },
      {
        name = "var_vpn511_gig2_511_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.30.1"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      }
      ]
    }
  ]
}