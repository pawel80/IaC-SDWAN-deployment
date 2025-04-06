resource "sdwan_system_feature_profile" "system_tst_01" {
  name        = "system_01"
  description = "My system feature profile"
}

resource "sdwan_transport_feature_profile" "transport_tst_01" {
  name        = "transport_01"
  description = "My transport feature profile"
}