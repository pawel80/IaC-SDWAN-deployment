###################################################################################
################################# SD-WAN Policies #################################
###################################################################################

########################## Centralized policy: HUB-SPOKE ##########################
resource "sdwan_site_list_policy_object" "hubs_v1" {
  name = "HUBS"
  entries = [
    {
      site_id = "901-903"
    }
  ]
}

resource "sdwan_site_list_policy_object" "spokes_v1" {
  name = "SPOKES"
  entries = [
    {
      site_id = "101-104"
    }
  ]
}

resource "sdwan_tloc_list_policy_object" "hub_tlocs_v1" {
  name = "HUB-TLOCS"
  entries = [
    {
      tloc_ip       = "99.9.1.1"
      color         = "private1"
      encapsulation = "gre"
      preference    = 10
    },
    {
      tloc_ip       = "99.9.2.1"
      color         = "private1"
      encapsulation = "gre"
      preference    = 10
    },
    {
      tloc_ip       = "99.9.3.1"
      color         = "private1"
      encapsulation = "gre"
      preference    = 10
    },
    {
      tloc_ip       = "99.9.1.1"
      color         = "private2"
      encapsulation = "ipsec"
      preference    = 10
    },
    {
      tloc_ip       = "99.9.2.1"
      color         = "private2"
      encapsulation = "ipsec"
      preference    = 10
    },
    {
      tloc_ip       = "99.9.3.1"
      color         = "private2"
      encapsulation = "ipsec"
      preference    = 10
    }
  ]
}

resource "sdwan_vpn_list_policy_object" "vpns_v1" {
  name = "VPNS"
  entries = [
    { vpn_id = "504" },
    { vpn_id = "400" },
    { vpn_id = "506" },
    { vpn_id = "600" }
  ]
}

resource "sdwan_ipv4_prefix_list_policy_object" "default_route_v1" {
  name = "DEFAULT-ROUTE"
  entries = [
    {
      prefix = "10.0.0.0/8"
    }
  ]
}

resource "sdwan_hub_and_spoke_topology_policy_definition" "hub_spoke_v1" {
  name        = "TOPOLOGY-HUB-SPOKE_v1"
  description = "Topology: HUB-SPOKE"
  vpn_list_id = sdwan_vpn_list_policy_object.vpns_v1.id
  topologies = [
    {
      name                = "HUB-SPOKE"
      all_hubs_are_equal  = true
      advertise_hub_tlocs = true
      tloc_list_id        = sdwan_tloc_list_policy_object.hub_tlocs_v1.id
      spokes = [
        {
          site_list_id = sdwan_site_list_policy_object.spokes_v1.id
          # hubs = [
          #   {
          #     site_list_id = sdwan_site_list_policy_object.hubs_v1.id
          #     preference   = "30"
          #     ipv4_prefix_list_ids = [sdwan_ipv4_prefix_list_policy_object.default_route_v1.id]
          #   }
          # ]
        }
      ]
    }
  ]
}

resource "sdwan_centralized_policy" "hub_spoke_policy_v1" {
  name        = "POLICY-HUB-SPOKE_v1"
  description = "Centralized Policy: HUB-SPOKE"
  definitions = [
    {
      id   = sdwan_hub_and_spoke_topology_policy_definition.hub_spoke_v1.id
      type = "hubAndSpoke"
      # entries = [
      #   {
      #     site_list_ids = [sdwan_site_list_policy_object.hubs_v1.id, sdwan_site_list_policy_object.spokes_v1.id]
      #     vpn_list_ids  = [sdwan_vpn_list_policy_object.vpns_v1.id]
      #     direction     = "out"
      #   }
      # ]
    }
  ]
}
# show running-config policy
# show running-config apply-policy



#--------------------- Activate/De-activate Centralized Policy --------------------
# resource "sdwan_activate_centralized_policy" "activate_centralized_policy_v1" {
#   id = sdwan_centralized_policy.hub_spoke_policy_v1.id
# }