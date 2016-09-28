module "coordination_cluster" {
  source = "../modules/cluster"

  infra = "${var.name}"
  name  = "coordination"

  // a map of region => zone,zone is passed in, we take the accumulation of all
  // these to determine the zones the cluster exists in
  zones = "${split(",", join(",", values(var.coordination_zones)))}"

  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  udp_cluster_firewall = "${var.coordination_udp_cluster_firewall}"
  tcp_cluster_firewall = "${var.coordination_tcp_cluster_firewall}"

  udp_range_firewall = "${var.coordination_udp_range_firewall}"
  tcp_range_firewall = "${var.coordination_tcp_range_firewall}"

}

module "coordination_region-us-west1" {
  source    = "../modules/static_cluster_region"
  parent_id = "${module.coordination_cluster.id}"

  region              = "us-west1"
  zones               = "${split(",", lookup(var.coordination_zones, "us-west1"))}"
  failover_zones = "${var.coordination_failover_zones}"
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  startup_script = "${var.coordination_startup_script}"
  machine_type = "${var.coordination_machine_type}"
  disk_image = "${var.coordination_disk_image}"

  // forwarding rules correspond to all of the unique port/port-ranges in the
  // firewall configurations
  tcp_forwarding_rules = "${distinct(compact(concat(
                            split(",", join(",", values(var.coordination_tcp_cluster_firewall))),
                            split(",", join(",", values(var.coordination_tcp_range_firewall)))
                          )))}"
  udp_forwarding_rules = "${distinct(compact(concat(
                            split(",", join(",", values(var.coordination_udp_cluster_firewall))),
                            split(",", join(",", values(var.coordination_udp_range_firewall)))
                          )))}"

  // internal to force dependency
  _zone_names_dep = "${module.coordination_cluster.subnetwork_names}"
}

module "coordination_region-us-central1" {
  source    = "../modules/static_cluster_region"
  parent_id = "${module.coordination_cluster.id}"

  region              = "us-central1"
  zones               = "${split(",", lookup(var.coordination_zones, "us-central1", ""))}"
  failover_zones = "${var.coordination_failover_zones}"
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  startup_script = "${var.coordination_startup_script}"
  machine_type = "${var.coordination_machine_type}"
  disk_image = "${var.coordination_disk_image}"

  // forwarding rules correspond to all of the unique port/port-ranges in the
  // firewall configurations
  tcp_forwarding_rules = "${distinct(compact(concat(
                            split(",", join(",", values(var.coordination_tcp_cluster_firewall))),
                            split(",", join(",", values(var.coordination_tcp_range_firewall)))
                          )))}"
  udp_forwarding_rules = "${distinct(compact(concat(
                            split(",", join(",", values(var.coordination_udp_cluster_firewall))),
                            split(",", join(",", values(var.coordination_udp_range_firewall)))
                          )))}"

  // internal to force dependency
  _zone_names_dep = "${module.coordination_cluster.subnetwork_names}"
}
