// internal addresses that correspond to the subnetwork allocated addresses
// present in the cluster
output "internal_addresses" {
  value = "${list(google_compute_instance.default.*.network_interface.0.address)}"
}

// public addresses correspond to address that are NAT addresses and are
// assigned by default when creating the instance without a static ip
output "public_addresses" {
  value = "${list(google_compute_instance.default.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

output "zone_target_pool_self_links" {
  value = "${list(google_compute_target_pool.primary.*.self_link)}"
}

output "region_target_pool_self_link" {
  value = "${google_compute_target_pool.region.self_link}"
}
