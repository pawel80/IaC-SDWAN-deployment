resource "iosxe_system" "system_all" {
  # Looping through the list of objects
  for_each                    = {for index,router in local.legacy_routers : router.name => router}
  device                      = each.value.name
  hostname                    = each.value.hostname
  # provider                    = iosxe.RT7
  ip_domain_lookup            = false
  ip_domain_name              = "lab.com"
}

resource "iosxe_interface_ethernet" "gig1" {
  # for_each                       = {for index,router in local.legacy_routers : router.name => router}
  for_each                       = {for router in local.legacy_routers : router.name => router}
  device                         = each.value.name
  type                           = "GigabitEthernet"
  name                           = "1"
  description                    = "INTRANET_OPEN"
  ipv4_address                   = each.value.ip_address
  ipv4_address_mask              = each.value.mask
  shutdown                       = false
}

resource "iosxe_interface_ethernet" "gig_2_4" {
  for_each                       = { for k, v in flatten([for router in local.legacy_routers :
                                      [for interface in try(router.shut_interfaces, []) : {
                                        "device"      = router.name
                                        "int_name"    = interface
                                      }]
                                    # ]) : "${v.device}_${v.int_name}" => v }
                                    ]) : v.device => v }
  device                         = each.value.device
  type                           = "GigabitEthernet"
  name                           = each.value.int_name
  description                    = "NOT-USED"
  shutdown                       = true
}

# Just to present CLI based config
resource "iosxe_cli" "global_loop123" {
  for_each                      = {for index,router in local.legacy_routers : router.name => router}
  device                        = each.value.name
  cli                           = <<-EOT
  interface Loopback111
  description CONFIGURE-VIA-RESTCONF-CLI
  EOT
}

resource "iosxe_save_config" "save_cfg" {
  for_each                       = {for index,router in local.legacy_routers : router.name => router}
  device                         = each.value.name
}
