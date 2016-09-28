// create a deterministic total number of instances, which correspond to the
// number of instances per zone for this cluster, times the total number of
// zones
resource "google_compute_instance" "default" {
  count = "${length(compact(var.zones)) * var.instances_per_zone}"

  // infra-name-zone-offset
  name = "${var.parent_id}-${element(var.zones, count.index % length(var.zones))}-${count.index % var.instances_per_zone}"

  machine_type   = "${var.machine_type}"
  zone           = "${element(var.zones, count.index % length(var.zones))}"
  can_ip_forward = true

  tags = "${list(
            "parent-${var.parent_id}",
            "zone-${element(var.zones, count.index % length(var.zones))}",
            "address-${cidrhost(lookup(var.cidr_blocks_by_zone, element(var.zones, count.index % length(var.zones))), count.index % var.instances_per_zone + 1)}"
          )}"

  disk {
    image       = "${var.disk_image}"
    auto_delete = true
  }

  metadata_startup_script = "${var.startup_script}"

  network_interface {
    // network is created by the cluster module, and is formatted via name: parent_id-zone
    subnetwork = "${var.parent_id}-${element(var.zones, count.index)}"

    // the ip address inside of the subnetwork is deterministic and corresponds to its offset in the cidr block.
    address = "${cidrhost(lookup(var.cidr_blocks_by_zone, element(var.zones, count.index % length(var.zones))), count.index % var.instances_per_zone + 1)}"

    access_config {
      // NOTE: by _not_ specifying a nat_ip, this block is granted a dynamic,
      // address that is auto generated and publicly accessible.
    }
  }
}

// for each zone, configure a backup pool
resource "google_compute_target_pool" "backup" {
  count = "${length(compact(var.zones))}"

  name = "${var.parent_id}-${element(var.zones, count.index)}-backup"

  // the instances in a backup target pool are either the instances that belong
  // to the configured failover zone, (as specified in the failover_zones)
  // mapfailover zone, (as specified in the failover_zones) mapfailover zone,
  // (as specified in the failover_zones) mapfailover zone, (as specified in
  // the failover_zones) map or if not specified, to the same zone (in the case
  // that no failover is desired).

  // instance name is of the format, zone/parentID-zone-offset
  instances = ["${formatlist(
              "${element(var.zones, count.index)}/${var.parent_id}-${lookup(var.failover_zones, element(var.zones, count.index), element(var.zones, count.index))}-%s",
              split(",", lookup(var._int_to_sequence, var.instances_per_zone)))}"]

  // by default, the target pool is placed in the project's region. This is
  // invalid, because the project is based in a region, but spans many regions
  region = "${var.region}"
}

// for each zone, create a target pool in the same region. Each target pool is
// configured with all of the zone's instances and is optionally configured to
// route to a backup pool.
resource "google_compute_target_pool" "primary" {
  count = "${length(compact(var.zones))}"

  name = "${var.parent_id}-${element(var.zones, count.index)}"

  // link to instances by zone/name. Each instance is named of the format: parent_id-zone-offset
  instances = ["${formatlist(
                      "${element(var.zones, count.index)}/${var.parent_id}-${element(var.zones, count.index % length(var.zones))}-%s",
                      split(",", lookup(var._int_to_sequence, var.instances_per_zone)))}"]

  // by default, the target pool is placed in the project's region. This is
  // invalid, because the project is based in a region, but spans many regions
  region = "${var.region}"

  // backup zones are optional. Users of this module can specify intelligent
  // back up policies by setting up a map, which denotes the zones to route
  // traffic to at the target level in the case that a zone pool goes down.
  backup_pool = "${element(google_compute_target_pool.backup.*.self_link, count.index)}"
  failover_ratio = "${var.failover_ratio}"
}

// each primary zone target pool corresponds to a set of forwarding rules which
// forward to the configured ports/port-ranges over tcp
resource "google_compute_forwarding_rule" "zone-tcp" {
  count = "${length(var.zones) * length(var.tcp_forwarding_rules)}"

  name = "${var.parent_id}-${element(var.zones, count.index % length(var.zones))}-${element(var.tcp_forwarding_rules, count.index % length(var.tcp_forwarding_rules))}"
  target = "${element(google_compute_target_pool.primary.*.self_link, count.index % length(var.zones))}"
  region = "${var.region}"

  ip_protocol = "tcp"
  port_range = "${element(var.tcp_forwarding_rules, count.index % length(var.tcp_forwarding_rules))}"
}

// each primary zone target pool corresponds to a set of forwarding rules which
// forward to the configured ports/port-ranges over udp
resource "google_compute_forwarding_rule" "zone-udp" {
  count = "${length(var.zones) * length(var.udp_forwarding_rules)}"

  name = "${var.parent_id}-${element(var.zones, count.index % length(var.zones))}-${element(var.udp_forwarding_rules, count.index % length(var.udp_forwarding_rules))}"
  target = "${element(google_compute_target_pool.primary.*.self_link, count.index % length(var.zones))}"
  region = "${var.region}"

  ip_protocol = "udp"
  port_range = "${element(var.udp_forwarding_rules, count.index % length(var.udp_forwarding_rules))}"
}

// create a single target pool which contains each of the instances in the
// entire region.
resource "google_compute_target_pool" "region" {
  name = "${var.parent_id}-${var.region}"

  instances = ["${list(google_compute_instance.default.*.self_link)}"]

  region = "${var.region}"
}

// a set of region based forwarding rules are created which forward traffic to
// the configured ports/port-ranges over tcp
resource "google_compute_forwarding_rule" "region-tcp" {
  count = "${length(var.tcp_forwarding_rules)}"
  name = "${var.parent_id}-${var.region}-tcp-${element(var.tcp_forwarding_rules, count.index)}"
  region = "${var.region}"
  target = "${google_compute_target_pool.region.self_link}"

  ip_protocol = "tcp"
  port_range = "${element(var.tcp_forwarding_rules, count.index % length(var.tcp_forwarding_rules))}"
}

// a set of region based forwarding rules are created which forward traffic to
// the configured ports/port-ranges over udp
resource "google_compute_forwarding_rule" "region-udp" {
  count = "${length(var.udp_forwarding_rules)}"
  name = "${var.parent_id}-${var.region}-udp-${element(var.udp_forwarding_rules, count.index)}"
  region = "${var.region}"
  target = "${google_compute_target_pool.region.self_link}"

  ip_protocol = "udp"
  port_range = "${element(var.udp_forwarding_rules, count.index % length(var.udp_forwarding_rules))}"
}
