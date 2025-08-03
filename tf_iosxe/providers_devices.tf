terraform {
  required_providers {
    iosxe = {
      # The source needs to be provided since this isn't one of the "official" HashiCorp providers
      source = "CiscoDevNet/iosxe"
      configuration_aliases = [ iosxe.cores ]
      # configuration_aliases = [ iosxe.RT7, iosxe.RT8 ]
      # configuration_aliases = [ iosxe.RTDC1R2 ]
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

# provider "iosxe" {
#   alias    = "RT7"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url      = "https://172.16.10.34"
# }

# provider "iosxe" {
#   alias    = "RT8"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url      = "https://172.16.10.38"
# }

# provider "iosxe" {
#   alias    = "RTDC1R2"
#   username = var.LEGACY_USERNAME
#   password = var.LEGACY_PASSWORD
#   url  = "https://172.16.51.2"
# }

locals {
  legacy_routers = [
    {
      name                      = "ROUTER7"
      url                       = "https://172.16.10.34"
      hostname                  = "S7R1"
      # mgmt_int                = "1"
      # ip_address              = "172.16.10.34"
      # mask                    = "255.255.255.252"
      shut_interfaces           = ["2", "3", "4"]
      edge_rd_vrf_502           = "7:502"
      edge_rd_vrf_200           = "7:200"
      edge_loop_52_desc         = "Legacy_Monitoring(open)"
      edge_loop_52_ip_address   = "11.1.7.1"
      edge_loop_52_mask         = "255.255.255.255"
      edge_loop_20_desc         = "Legacy_Services(open)"
      edge_loop_20_ip_address   = "192.168.207.2"
      edge_loop_20_mask         = "255.255.255.252"
    },
    {
      name                      = "ROUTER8"
      url                       = "https://172.16.10.38"
      hostname                  = "S8R1"
      # mgmt_int                = "1"
      # ip_address              = "172.16.10.38"
      # mask                    = "255.255.255.252"
      shut_interfaces           = ["2", "3", "4"]
      edge_rd_vrf_502           = "8:502"
      edge_rd_vrf_200           = "8:200"
      edge_loop_52_desc         = "Legacy_Monitoring(open)"
      edge_loop_52_ip_address   = "11.1.8.1"
      edge_loop_52_mask         = "255.255.255.255"
      edge_loop_20_desc         = "Legacy_Services(open)"
      edge_loop_20_ip_address   = "192.168.208.2"
      edge_loop_20_mask         = "255.255.255.252"

    }
  ]

  legacy_core_routers = [
    {
      name                      = "ROUTER_DC1R2"
      url                       = "https://172.16.51.2"
      hostname                  = "DC1R2"
      # gig2_ip_address         = "172.16.51.2"
      # gig2_mask               = "255.255.255.252"
      shut_interfaces           = ["4"]
      loop_99_ip_address        = "10.99.10.1"
      loop_99_mask              = "255.255.255.255"
      loop_99_desc              = "For default route summary"
      loop_54_ip_address        = "99.9.1.2"
      loop_54_mask              = "255.255.255.255"
      loop_54_desc              = "Monitoring"
      loop_56_ip_address        = "10.99.56.1"
      loop_56_mask              = "255.255.255.255"
      loop_56_desc              = "For default route summary"
      loop_60_ip_address        = "10.99.60.1"
      loop_60_mask              = "255.255.255.255"
      loop_60_desc              = "For default route summary"
      gig1_ip_address           = "192.168.12.1"
      gig1_mask                 = "255.255.255.252"
      gig1_desc                 = "DC1R2-DC2R2"
      gig2_502_ip_address       = "172.16.52.2"
      gig2_502_mask             = "255.255.255.252"
      gig2_502_desc             = "Legacy_Monitoring(open)"
      gig2_200_ip_address       = "192.168.20.2"
      gig2_200_mask             = "255.255.255.252"
      gig2_200_desc             = "Legacy_Services(open)"
      gig2_503_ip_address       = "172.16.53.2"
      gig2_503_mask             = "255.255.255.252"
      gig2_503_desc             = "SD-Routing_Monitoring(open)"
      gig2_300_ip_address       = "192.168.30.2"
      gig2_300_mask             = "255.255.255.252"
      gig2_300_desc             = "SD-Routing_Services(open)"
      gig2_504_ip_address       = "172.16.54.2"
      gig2_504_mask             = "255.255.255.252"
      gig2_504_desc             = "SD-WAN_Monitoring(open)"
      gig2_400_ip_address       = "192.168.40.2"
      gig2_400_mask             = "255.255.255.252"
      gig2_400_desc             = "SD-WAN_Services(open)"
      gig2_506_ip_address       = "172.16.56.2"
      gig2_506_mask             = "255.255.255.252"
      gig2_506_desc             = "SD-WAN_Monitoring(sec)"
      gig2_600_ip_address       = "192.168.60.2"
      gig2_600_mask             = "255.255.255.252"
      gig2_600_desc             = "SD-WAN_Services(sec)"
      gig3_ip_address           = "192.168.13.1"
      gig3_mask                 = "255.255.255.252"
      gig3_desc                 = "DC1R2-DC3R2"
      rd_vrf_506                = "65101:506"
      rd_vrf_600                = "65101:600"
      bgp_asn                   = "65101"
      bgp_nb1_desc              = "DC2R2"
      bgp_nb1_asn               = "65201"
      bgp_nb1_ip_address        = "192.168.12.2"
      bgp_nb2_desc              = "DC3R2"
      bgp_nb2_asn               = "65301"
      bgp_nb2_ip_address        = "192.168.13.2"
      bgp_nb3_502_desc          = "DC1R1-VPN:502"
      bgp_nb3_502_asn           = "65101"
      bgp_nb3_502_ip_address    = "172.16.52.1"
      bgp_nb3_200_desc          = "DC1R1-VPN:200"
      bgp_nb3_200_asn           = "65101"
      bgp_nb3_200_ip_address    = "192.168.20.1"
      bgp_nb3_503_desc          = "DC1R1-VPN:503"
      bgp_nb3_503_asn           = "65101"
      bgp_nb3_503_ip_address    = "172.16.53.1"
      bgp_nb3_300_desc          = "DC1R1-VPN:300"
      bgp_nb3_300_asn           = "65101"
      bgp_nb3_300_ip_address    = "192.168.30.1"
      bgp_nb3_504_desc          = "DC1R1-VPN:504"
      bgp_nb3_504_asn           = "65101"
      bgp_nb3_504_ip_address    = "172.16.54.1"
      bgp_nb3_400_desc          = "DC1R1-VPN:400"
      bgp_nb3_400_asn           = "65101"
      bgp_nb3_400_ip_address    = "192.168.40.1"
      bgp_nb3_506_desc          = "DC1R1-VPN:506"
      bgp_nb3_506_asn           = "65101"
      bgp_nb3_506_ip_address    = "172.16.56.1"
      bgp_nb3_600_desc          = "DC1R1-VPN:600"
      bgp_nb3_600_asn           = "65101"
      bgp_nb3_600_ip_address    = "192.168.60.1"
    },
    {
      name                      = "ROUTER_DC2R2"
      url                       = "https://172.16.51.6"
      hostname                  = "DC2R2"
      # gig2_ip_address         = "172.16.51.6"
      # gig2_mask               = "255.255.255.252"
      shut_interfaces           = ["4"]
      loop_99_ip_address        = "10.99.10.2"
      loop_99_mask              = "255.255.255.255"
      loop_99_desc              = "For default route summary"
      loop_54_ip_address        = "99.9.2.2"
      loop_54_mask              = "255.255.255.255"
      loop_54_desc              = "Monitoring"
      loop_56_ip_address        = "10.99.56.2"
      loop_56_mask              = "255.255.255.255"
      loop_56_desc              = "For default route summary"
      loop_60_ip_address        = "10.99.60.2"
      loop_60_mask              = "255.255.255.255"
      loop_60_desc              = "For default route summary"
      gig1_ip_address           = "192.168.12.2"
      gig1_mask                 = "255.255.255.252"
      gig1_desc                 = "DC2R2-DC1R2"
      gig2_502_ip_address       = "172.16.52.6"
      gig2_502_mask             = "255.255.255.252"
      gig2_502_desc             = "Legacy_Monitoring(open)"
      gig2_200_ip_address       = "192.168.20.6"
      gig2_200_mask             = "255.255.255.252"
      gig2_200_desc             = "Legacy_Services(open)"
      gig2_503_ip_address       = "172.16.53.6"
      gig2_503_mask             = "255.255.255.252"
      gig2_503_desc             = "SD-Routing_Monitoring(open)"
      gig2_300_ip_address       = "192.168.30.6"
      gig2_300_mask             = "255.255.255.252"
      gig2_300_desc             = "SD-Routing_Services(open)"
      gig2_504_ip_address       = "172.16.54.6"
      gig2_504_mask             = "255.255.255.252"
      gig2_504_desc             = "SD-WAN_Monitoring(open)"
      gig2_400_ip_address       = "192.168.40.6"
      gig2_400_mask             = "255.255.255.252"
      gig2_400_desc             = "SD-WAN_Services(open)"
      gig2_506_ip_address       = "172.16.56.6"
      gig2_506_mask             = "255.255.255.252"
      gig2_506_desc             = "SD-WAN_Monitoring(sec)"
      gig2_600_ip_address       = "192.168.60.6"
      gig2_600_mask             = "255.255.255.252"
      gig2_600_desc             = "SD-WAN_Services(sec)"
      gig3_ip_address           = "192.168.23.1"
      gig3_mask                 = "255.255.255.252"
      gig3_desc                 = "DC2R2-DC3R2"
      rd_vrf_506                = "65201:506"
      rd_vrf_600                = "65201:600"
      bgp_asn                   = "65201"
      bgp_nb1_desc              = "DC1R2"
      bgp_nb1_asn               = "65101"
      bgp_nb1_ip_address        = "192.168.12.1"
      bgp_nb2_desc              = "DC3R2"
      bgp_nb2_asn               = "65301"
      bgp_nb2_ip_address        = "192.168.23.2"
      bgp_nb3_502_desc          = "DC2R1-VPN:502"
      bgp_nb3_502_asn           = "65201"
      bgp_nb3_502_ip_address    = "172.16.52.5"
      bgp_nb3_200_desc          = "DC2R1-VPN:200"
      bgp_nb3_200_asn           = "65201"
      bgp_nb3_200_ip_address    = "192.168.20.5"
      bgp_nb3_503_desc          = "DC2R1-VPN:503"
      bgp_nb3_503_asn           = "65201"
      bgp_nb3_503_ip_address    = "172.16.53.5"
      bgp_nb3_300_desc          = "DC2R1-VPN:300"
      bgp_nb3_300_asn           = "65201"
      bgp_nb3_300_ip_address    = "192.168.30.5"
      bgp_nb3_504_desc          = "DC2R1-VPN:504"
      bgp_nb3_504_asn           = "65201"
      bgp_nb3_504_ip_address    = "172.16.54.5"
      bgp_nb3_400_desc          = "DC2R1-VPN:400"
      bgp_nb3_400_asn           = "65201"
      bgp_nb3_400_ip_address    = "192.168.40.5"
      bgp_nb3_506_desc          = "DC2R1-VPN:506"
      bgp_nb3_506_asn           = "65201"
      bgp_nb3_506_ip_address    = "172.16.56.5"
      bgp_nb3_600_desc          = "DC2R1-VPN:600"
      bgp_nb3_600_asn           = "65201"
      bgp_nb3_600_ip_address    = "192.168.60.5"
    },
    {
      name                      = "ROUTER_DC3R2"
      url                       = "https://172.16.51.10"
      hostname                  = "DC3R2"
      # gig2_ip_address         = "172.16.51.10"
      # gig2_mask               = "255.255.255.252"
      shut_interfaces           = ["4"]
      loop_99_ip_address        = "10.99.10.3"
      loop_99_mask              = "255.255.255.255"
      loop_99_desc              = "For default route summary"
      loop_54_ip_address        = "99.9.3.2"
      loop_54_mask              = "255.255.255.255"
      loop_54_desc              = "Monitoring"
      loop_56_ip_address        = "10.99.56.3"
      loop_56_mask              = "255.255.255.255"
      loop_56_desc              = "For default route summary"
      loop_60_ip_address        = "10.99.60.3"
      loop_60_mask              = "255.255.255.255"
      loop_60_desc              = "For default route summary"
      gig1_ip_address           = "192.168.23.2"
      gig1_mask                 = "255.255.255.252"
      gig1_desc                 = "DC3R2-DC2R2"
      gig2_502_ip_address       = "172.16.52.10"
      gig2_502_mask             = "255.255.255.252"
      gig2_502_desc             = "Legacy_Monitoring(open)"
      gig2_200_ip_address       = "192.168.20.10"
      gig2_200_mask             = "255.255.255.252"
      gig2_200_desc             = "Legacy_Services(open)"
      gig2_503_ip_address       = "172.16.53.10"
      gig2_503_mask             = "255.255.255.252"
      gig2_503_desc             = "SD-Routing_Monitoring(open)"
      gig2_300_ip_address       = "192.168.30.10"
      gig2_300_mask             = "255.255.255.252"
      gig2_300_desc             = "SD-Routing_Services(open)"
      gig2_504_ip_address       = "172.16.54.10"
      gig2_504_mask             = "255.255.255.252"
      gig2_504_desc             = "SD-WAN_Monitoring(open)"
      gig2_400_ip_address       = "192.168.40.10"
      gig2_400_mask             = "255.255.255.252"
      gig2_400_desc             = "SD-WAN_Services(open)"
      gig2_506_ip_address       = "172.16.56.10"
      gig2_506_mask             = "255.255.255.252"
      gig2_506_desc             = "SD-WAN_Monitoring(sec)"
      gig2_600_ip_address       = "192.168.60.10"
      gig2_600_mask             = "255.255.255.252"
      gig2_600_desc             = "SD-WAN_Services(sec)"
      gig3_ip_address           = "192.168.13.2"
      gig3_mask                 = "255.255.255.252"
      gig3_desc                 = "DC32R2-DC1R2"
      rd_vrf_506                = "65301:506"
      rd_vrf_600                = "65301:600"
      bgp_asn                   = "65301"
      bgp_nb1_desc              = "DC2R2"
      bgp_nb1_asn               = "65201"
      bgp_nb1_ip_address        = "192.168.23.1"
      bgp_nb2_desc              = "DC1R2"
      bgp_nb2_asn               = "65101"
      bgp_nb2_ip_address        = "192.168.13.1"
      bgp_nb3_502_desc          = "DC3R1-VPN:502"
      bgp_nb3_502_asn           = "65301"
      bgp_nb3_502_ip_address    = "172.16.52.9"
      bgp_nb3_200_desc          = "DC3R1-VPN:200"
      bgp_nb3_200_asn           = "65301"
      bgp_nb3_200_ip_address    = "192.168.20.9"
      bgp_nb3_503_desc          = "DC3R1-VPN:503"
      bgp_nb3_503_asn           = "65301"
      bgp_nb3_503_ip_address    = "172.16.53.9"
      bgp_nb3_300_desc          = "DC3R1-VPN:300"
      bgp_nb3_300_asn           = "65301"
      bgp_nb3_300_ip_address    = "192.168.30.9"
      bgp_nb3_504_desc          = "DC3R1-VPN:504"
      bgp_nb3_504_asn           = "65301"
      bgp_nb3_504_ip_address    = "172.16.54.9"
      bgp_nb3_400_desc          = "DC3R1-VPN:400"
      bgp_nb3_400_asn           = "65301"
      bgp_nb3_400_ip_address    = "192.168.40.9"
      bgp_nb3_506_desc          = "DC3R1-VPN:506"
      bgp_nb3_506_asn           = "65301"
      bgp_nb3_506_ip_address    = "172.16.56.9"
      bgp_nb3_600_desc          = "DC3R1-VPN:600"
      bgp_nb3_600_asn           = "65301"
      bgp_nb3_600_ip_address    = "192.168.60.9"
    }
  ]
  # For test purpose:
  #   flat_object = { for k, v in flatten([for router in local.legacy_routers :
  #     [for interface in try(router.shut_interfaces, []) : {
  #       "device"      = router.name
  #       "name"        = interface
  #       "type"        = "GigabitEthernet"
  #       "description" = "NOT-USED"
  #     }]
  # ]) : "${v.device}_${v.name}_${v.type}_${v.description}" => v }
}

# output "flat_object" {
#   value = local.flat_object
# }

provider "iosxe" {
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  devices  = local.legacy_routers
}

# Same provider, different device list
provider "iosxe" {
  alias    = "cores"
  username = var.LEGACY_USERNAME
  password = var.LEGACY_PASSWORD
  devices  = local.legacy_core_routers
}
