// create a firewall allowing traffic from the origin clusters (by tag) over
// tcp to the specified ports
resource "google_compute_firewall" "tcp_cluster" {
  count = "${length(keys(var.tcp_cluster_firewall_configuration))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.tcp_cluster_firewall_configuration), count.index)}-tcp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = "${compact(split(",", lookup(var.tcp_cluster_firewall_configuration, element(keys(var.tcp_cluster_firewall_configuration), count.index))))}"
  }

  source_tags = "${list("${var.infra}-${element(keys(var.tcp_cluster_firewall_configuration), count.index)}")}"
  target_tags = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin clusters (by tag) over
// udp to the specified ports
resource "google_compute_firewall" "udp_cluster" {
  count = "${length(keys(var.udp_cluster_firewall_configuration))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.udp_cluster_firewall_configuration), count.index)}-udp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "udp"
    ports    = "${compact(split(",", lookup(var.udp_cluster_firewall_configuration, element(keys(var.udp_cluster_firewall_configuration), count.index))))}"
  }

  source_tags = "${list("${var.infra}-${element(keys(var.udp_cluster_firewall_configuration), count.index)}")}"
  target_tags = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin source ranges over tcp to
// the specified ports
resource "google_compute_firewall" "tcp_range" {
  count = "${length(keys(var.tcp_range_firewall_configuration))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.tcp_range_firewall_configuration), count.index)}-tcp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "tcp"
    ports    = "${compact(split(",", lookup(var.tcp_range_firewall_configuration, element(keys(var.tcp_range_firewall_configuration), count.index))))}"
  }

  source_range = "${lookup(var.tcp_range_firewall_configuration, element(keys(var.tcp_range_firewall_configuration), count.index))}"
  target_tags  = "${list("${var.infra}-${var.name}")}"
}

// create a firewall allowing traffic from the origin source ranges over udp to
// the specified ports
resource "google_compute_firewall" "udp_range" {
  count = "${length(keys(var.udp_range_firewall_configuration))}"

  name    = "${var.infra}-${var.name}-${element(keys(var.udp_range_firewall_configuration), count.index)}-udp"
  network = "${google_compute_network.default.name}"

  allow {
    protocol = "udp"
    ports    = "${compact(split(",", lookup(var.udp_range_firewall_configuration, element(keys(var.udp_range_firewall_configuration), count.index))))}"
  }

  source_range = "${lookup(var.udp_range_firewall_configuration, element(keys(var.udp_range_firewall_configuration), count.index))}"
  target_tags  = "${list("${var.infra}-${var.name}")}"
}
