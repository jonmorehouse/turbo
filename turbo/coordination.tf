// parent network that wraps subnetworks in each specified region
resource "google_compute_network" "default" {
  name                    = "${var.name}-coordination"
  description             = "network"
  auto_create_subnetworks = "false"
}

module "coordination_region-us-west1" {
  source    = "../modules/static_cluster_region"

  parent_id = "${var.name}-coordination"
  network = "${google_compute_network.default.self_link}"

  region              = "us-west1"

  // zone configuration
  zones               = "${split(",", lookup(var.coordination_zones, "us-west1"))}"
  failover_zones = "${var.coordination_failover_zones}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  // instance configuration
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  startup_script = "${var.coordination_startup_script}"
  machine_type = "${var.coordination_machine_type}"
  disk_image = "${var.coordination_disk_image}"

  // firewall configuration
  udp_cluster_firewall = "${var.coordination_udp_cluster_firewall}"
  tcp_cluster_firewall = "${var.coordination_tcp_cluster_firewall}"

  udp_range_firewall = "${var.coordination_udp_range_firewall}"
  tcp_range_firewall = "${var.coordination_tcp_range_firewall}"

  cluster_tags = {
    "core" = "${var.name}-core"
    "public" = "${var.name}-public"
    "service" = "${var.name}-service"
  }

  // routing configuration
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
}

module "coordination_region-us-central1" {
  source    = "../modules/static_cluster_region"

  parent_id = "${var.name}-coordination"
  network = "${google_compute_network.default.self_link}"

  region              = "us-central1"

  // zone configuration
  zones               = "${split(",", lookup(var.coordination_zones, "us-central1"))}"
  failover_zones = "${var.coordination_failover_zones}"
  cidr_blocks_by_zone = "${var.coordination_cidr_blocks_by_zone}"

  // instance configuration
  instances_per_zone  = "${var.coordination_instances_per_zone}"
  startup_script = "${var.coordination_startup_script}"
  machine_type = "${var.coordination_machine_type}"
  disk_image = "${var.coordination_disk_image}"

  // firewall configuration
  udp_cluster_firewall = "${var.coordination_udp_cluster_firewall}"
  tcp_cluster_firewall = "${var.coordination_tcp_cluster_firewall}"

  udp_range_firewall = "${var.coordination_udp_range_firewall}"
  tcp_range_firewall = "${var.coordination_tcp_range_firewall}"

  cluster_tags = {
    "core" = "${var.name}-core"
    "public" = "${var.name}-public"
    "service" = "${var.name}-service"
  }

  // routing configuration
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
}
