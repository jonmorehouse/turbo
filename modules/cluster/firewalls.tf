// create a firewall allowing traffic from the origin clusters (by tag) over
// tcp to the specified ports
resource "google_compute_firewall" "tcp_cluster" {
  count = "${length(keys(var.tcp_cluster_firewall))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.tcp_cluster_firewall), count.index)}-tcp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = "${compact(split(",", lookup(var.tcp_cluster_firewall, element(keys(var.tcp_cluster_firewall), count.index))))}"
  }

  source_tags = "${list("${var.infra}-${element(keys(var.tcp_cluster_firewall), count.index)}")}"
  target_tags = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin clusters (by tag) over
// udp to the specified ports
resource "google_compute_firewall" "udp_cluster" {
  count = "${length(keys(var.udp_cluster_firewall))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.udp_cluster_firewall), count.index)}-udp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "udp"
    ports    = "${compact(split(",", lookup(var.udp_cluster_firewall, element(keys(var.udp_cluster_firewall), count.index))))}"
  }

  source_tags = "${list("${var.infra}-${element(keys(var.udp_cluster_firewall), count.index)}")}"
  target_tags = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin source ranges over tcp to
// the specified ports
resource "google_compute_firewall" "tcp_range" {
  count = "${length(keys(var.tcp_range_firewall))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.tcp_range_firewall), count.index)}-tcp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = "${compact(split(",", lookup(var.tcp_range_firewall, element(keys(var.tcp_range_firewall), count.index))))}"
  }

  source_ranges = "${list(lookup(var.tcp_range_firewall, element(keys(var.tcp_range_firewall), count.index)))}"
  target_tags  = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin source ranges over udp to
// the specified ports
resource "google_compute_firewall" "udp_range" {
  count = "${length(keys(var.udp_range_firewall))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.udp_range_firewall), count.index)}-udp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "udp"
    ports    = "${compact(split(",", lookup(var.udp_range_firewall, element(keys(var.udp_range_firewall), count.index))))}"
  }

  source_ranges = "${list(lookup(var.udp_range_firewall, element(keys(var.udp_range_firewall), count.index)))}"
  target_tags  = "${list("${var.infra}-${var.name}")}"
}
