module "coordination_cluster" {
  source = "../modules/cluster"

  infra = "${var.name}"
  name  = "coordination"

  // a map of region => zone,zone is passed in, we take the accumulation of all
  // these to determine the zones the cluster exists in
  zones = "${split(",", join(",", values(var.coordination_zones)))}"

  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  udp_cluster_firewall_configuration = "${var.coordination_udp_port_configuration}"
  tcp_cluster_firewall_configuration = "${var.coordination_tcp_port_configuration}"

  udp_range_firewall_configuration = "${var.coordination_udp_range_firewall_configuration}"
  tcp_range_firewall_configuration = "${var.coordination_tcp_range_firewall_configuration}"
}

// coordination static region is responsible for accepting a list of instances, and outputting a target pool to it ...
module "coordination_region-us-west1" {
  source    = "../modules/static_cluster_region"
  parent_id = "${module.coordination_cluster.id}"

  region              = "us-west1"
  zones               = "${split(",", lookup(var.coordination_zones, "us-west1"))}"
  failover_zones = "${var.coordination_failover_zones}"
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"
}

module "coordination_region-us-central1" {
  source    = "../modules/static_cluster_region"
  parent_id = "${module.coordination_cluster.id}"

  region              = "us-central1"
  zones               = "${split(",", lookup(var.coordination_zones, "us-central1", ""))}"
  failover_zones = "${var.coordination_failover_zones}"
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"
}

output "debug" {
  value = "debug"
}

// coordination internal addresses is the
output "coordination_internal_addresses" {
  value = "TBD"
}
