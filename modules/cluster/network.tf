// parent network that wraps subnetworks in each specified region
resource "google_compute_network" "default" {
  name                    = "${var.infra}-${var.name}"
  description             = "network"
  auto_create_subnetworks = "false"
}

// a single google subnetwork is created for each zone
resource "google_compute_subnetwork" "default" {
  count       = "${length(var.zones)}"
  description = "each zone, per cluster has one unique subnetwork"

  // name is infra-name-zone
  name = "${var.infra}-${var.name}-${element(var.zones, count.index)}"

  network       = "${google_compute_network.default.self_link}"
  region        = "${lookup(var._zones_to_region, element(var.zones, count.index))}"
  ip_cidr_range = "${lookup(var.cidr_blocks_by_zone, element(var.zones, count.index))}"
}
