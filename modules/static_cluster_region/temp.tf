variable "network_link" {}

// a single google subnetwork is created for each zone
resource "google_compute_subnetwork" "default" {
  count       = "${length(var.zones)}"
  description = "each zone, per cluster has one unique subnetwork"

  // name is infra-name-zone
  name = "${var.parent_id}-${element(var.zones, count.index)}"

  network       = "${var.network_link}"
  region        = "${lookup(var._zones_to_region, element(var.zones, count.index))}"

  ip_cidr_range = "${lookup(var.cidr_blocks_by_zone, element(var.zones, count.index))}"
}

// thought - by moving the firewalls into here, we can also have more control
// over them; ie: only open access the subnetworks we care about
