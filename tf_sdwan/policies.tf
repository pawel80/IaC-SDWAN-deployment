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

resource "sdwan_vpn_list_policy_object" "vpns_v1" {
  name = "VPNS"
  entries = [
    { vpn_id = "504" },
    { vpn_id = "400" },
    { vpn_id = "506" },
    { vpn_id = "600" }
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
      # tloc_list_id        = "b326e448-bf33-47e4-83e7-f947e6981382"
      spokes = [
        {
          site_list_id = sdwan_site_list_policy_object.spokes_v1.id
          hubs = [
            {
              site_list_id = sdwan_site_list_policy_object.hubs_v1.id
              preference   = "30"
            }
          ]
        }
      ]
    }
  ]
}

# resource "sdwan_centralized_policy" "example" {
#   name        = "Example"
#   description = "My description"
#   definitions = [
#     {
#       id   = "2081c2f4-3f9f-4fee-8078-dcc8904e368d"
#       type = "hubAndSpoke"
#       entries = [
#         {
#           site_list_ids = ["2081c2f4-3f9f-4fee-8078-dcc8904e368d"]
#           vpn_list_ids  = ["7d0c2444-8743-4414-add0-866945ea9f70"]
#           direction     = "service"
#         }
#       ]
#     }
#   ]
# }

# resource "sdwan_activate_centralized_policy" "example" {
#   id = sdwan_centralized_policy.POLICY1.id
# }