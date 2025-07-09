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
    id     = var.S1R1_id
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
    id     = var.S1R1_id
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
        name = "var_gig2_502_if_address"
        value = "172.16.52.1"
      },
      {
        name = "var_gig2_502_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_200_if_address"
        value = "192.168.20.1"
      },
      {
        name = "var_gig2_200_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_503_if_address"
        value = "172.16.53.1"
      },
      {
        name = "var_gig2_503_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_300_if_address"
        value = "192.168.30.1"
      },
      {
        name = "var_gig2_300_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_504_if_address"
        value = "172.16.54.1"
      },
      {
        name = "var_gig2_504_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.40.1"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_506_if_address"
        value = "172.16.56.1"
      },
      {
        name = "var_gig2_506_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_600_if_address"
        value = "192.168.60.1"
      },
      {
        name = "var_gig2_600_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_bgp_asn"
        value = "65101"
      },
      {
        name = "var_nb_502_ip_address"
        value = "172.16.52.2"
      },
      {
        name = "var_nb_502_desc"
        value = "DC1R2-VPN:502"
      },
      {
        name = "var_nb_502_asn"
        value = "65101"
      },
      {
        name = "var_nb_200_ip_address"
        value = "192.168.20.2"
      },
      {
        name = "var_nb_200_desc"
        value = "DC1R2-VPN:200"
      },
      {
        name = "var_nb_200_asn"
        value = "65101"
      },
      {
        name = "var_nb_503_ip_address"
        value = "172.16.53.2"
      },
      {
        name = "var_nb_503_desc"
        value = "DC1R2-VPN:503"
      },
      {
        name = "var_nb_503_asn"
        value = "65101"
      },
      {
        name = "var_nb_300_ip_address"
        value = "192.168.30.2"
      },
      {
        name = "var_nb_300_desc"
        value = "DC1R2-VPN:300"
      },
      {
        name = "var_nb_300_asn"
        value = "65101"
      },
      {
        name = "var_nb_504_ip_address"
        value = "172.16.54.2"
      },
      {
        name = "var_nb_504_desc"
        value = "DC1R2-VPN:504"
      },
      {
        name = "var_nb_504_asn"
        value = "65101"
      },
      {
        name = "var_nb_400_ip_address"
        value = "192.168.40.2"
      },
      {
        name = "var_nb_400_desc"
        value = "DC1R2-VPN:400"
      },
      {
        name = "var_nb_400_asn"
        value = "65101"
      },
      {
        name = "var_nb_506_ip_address"
        value = "172.16.56.2"
      },
      {
        name = "var_nb_506_desc"
        value = "DC1R2-VPN:506"
      },
      {
        name = "var_nb_506_asn"
        value = "65101"
      },
      {
        name = "var_nb_600_ip_address"
        value = "192.168.60.2"
      },
      {
        name = "var_nb_600_desc"
        value = "DC1R2-VPN:600"
      },
      {
        name = "var_nb_600_asn"
        value = "65101"
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
        name = "var_gig2_502_if_address"
        value = "172.16.52.5"
      },
      {
        name = "var_gig2_502_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_200_if_address"
        value = "192.168.20.5"
      },
      {
        name = "var_gig2_200_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_503_if_address"
        value = "172.16.53.5"
      },
      {
        name = "var_gig2_503_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_300_if_address"
        value = "192.168.30.5"
      },
      {
        name = "var_gig2_300_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_504_if_address"
        value = "172.16.54.5"
      },
      {
        name = "var_gig2_504_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.40.5"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_506_if_address"
        value = "172.16.56.5"
      },
      {
        name = "var_gig2_506_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_600_if_address"
        value = "192.168.60.5"
      },
      {
        name = "var_gig2_600_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_bgp_asn"
        value = "65201"
      },
      {
        name = "var_nb_502_ip_address"
        value = "172.16.52.6"
      },
      {
        name = "var_nb_502_desc"
        value = "DC2R2-VPN:502"
      },
      {
        name = "var_nb_502_asn"
        value = "65201"
      },
      {
        name = "var_nb_200_ip_address"
        value = "192.168.20.6"
      },
      {
        name = "var_nb_200_desc"
        value = "DC2R2-VPN:200"
      },
      {
        name = "var_nb_200_asn"
        value = "65201"
      },
      {
        name = "var_nb_503_ip_address"
        value = "172.16.53.6"
      },
      {
        name = "var_nb_503_desc"
        value = "DC2R2-VPN:503"
      },
      {
        name = "var_nb_503_asn"
        value = "65201"
      },
      {
        name = "var_nb_300_ip_address"
        value = "192.168.30.6"
      },
      {
        name = "var_nb_300_desc"
        value = "DC2R2-VPN:300"
      },
      {
        name = "var_nb_300_asn"
        value = "65201"
      },
      {
        name = "var_nb_504_ip_address"
        value = "172.16.54.6"
      },
      {
        name = "var_nb_504_desc"
        value = "DC2R2-VPN:504"
      },
      {
        name = "var_nb_504_asn"
        value = "65201"
      },
      {
        name = "var_nb_400_ip_address"
        value = "192.168.40.6"
      },
      {
        name = "var_nb_400_desc"
        value = "DC2R2-VPN:400"
      },
      {
        name = "var_nb_400_asn"
        value = "65201"
      },
      {
        name = "var_nb_506_ip_address"
        value = "172.16.56.6"
      },
      {
        name = "var_nb_506_desc"
        value = "DC2R2-VPN:506"
      },
      {
        name = "var_nb_506_asn"
        value = "65201"
      },
      {
        name = "var_nb_600_ip_address"
        value = "192.168.60.6"
      },
      {
        name = "var_nb_600_desc"
        value = "DC2R2-VPN:600"
      },
      {
        name = "var_nb_600_asn"
        value = "65201"
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
        name = "var_gig2_502_if_address"
        value = "172.16.52.9"
      },
      {
        name = "var_gig2_502_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_200_if_address"
        value = "192.168.20.9"
      },
      {
        name = "var_gig2_200_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_503_if_address"
        value = "172.16.53.9"
      },
      {
        name = "var_gig2_503_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_300_if_address"
        value = "192.168.30.9"
      },
      {
        name = "var_gig2_300_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_504_if_address"
        value = "172.16.54.9"
      },
      {
        name = "var_gig2_504_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_400_if_address"
        value = "192.168.40.9"
      },
      {
        name = "var_gig2_400_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_506_if_address"
        value = "172.16.56.9"
      },
      {
        name = "var_gig2_506_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_gig2_600_if_address"
        value = "192.168.60.9"
      },
      {
        name = "var_gig2_600_if_mask"
        value = "255.255.255.252"
      },
      {
        name = "var_bgp_asn"
        value = "65301"
      },
      {
        name = "var_nb_502_ip_address"
        value = "172.16.52.10"
      },
      {
        name = "var_nb_502_desc"
        value = "DC3R2-VPN:502"
      },
      {
        name = "var_nb_502_asn"
        value = "65301"
      },
      {
        name = "var_nb_200_ip_address"
        value = "192.168.20.10"
      },
      {
        name = "var_nb_200_desc"
        value = "DC3R2-VPN:200"
      },
      {
        name = "var_nb_200_asn"
        value = "65301"
      },
      {
        name = "var_nb_503_ip_address"
        value = "172.16.53.10"
      },
      {
        name = "var_nb_503_desc"
        value = "DC3R2-VPN:503"
      },
      {
        name = "var_nb_503_asn"
        value = "65301"
      },
      {
        name = "var_nb_300_ip_address"
        value = "192.168.30.10"
      },
      {
        name = "var_nb_300_desc"
        value = "DC3R2-VPN:300"
      },
      {
        name = "var_nb_300_asn"
        value = "65301"
      },
      {
        name = "var_nb_504_ip_address"
        value = "172.16.54.10"
      },
      {
        name = "var_nb_504_desc"
        value = "DC3R2-VPN:504"
      },
      {
        name = "var_nb_504_asn"
        value = "65301"
      },
      {
        name = "var_nb_400_ip_address"
        value = "192.168.40.10"
      },
      {
        name = "var_nb_400_desc"
        value = "DC3R2-VPN:400"
      },
      {
        name = "var_nb_400_asn"
        value = "65301"
      },
      {
        name = "var_nb_506_ip_address"
        value = "172.16.56.10"
      },
      {
        name = "var_nb_506_desc"
        value = "DC3R2-VPN:506"
      },
      {
        name = "var_nb_506_asn"
        value = "65301"
      },
      {
        name = "var_nb_600_ip_address"
        value = "192.168.60.10"
      },
      {
        name = "var_nb_600_desc"
        value = "DC3R2-VPN:600"
      },
      {
        name = "var_nb_600_asn"
        value = "65301"
      }
      ]
    }
  ]
}