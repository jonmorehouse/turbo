resource "google_compute_instance_template" "default" {
  count = "${length(var.zones)}"
  name  = "${var.infra}-${var.cluster}-${element(var.zones, count.index)}"

  machine_type   = "${var.machine_type}"
  can_ip_forward = true

  tags = "${list("${var.infra}-${var.cluster}", "infra-${var.infra}", "cluster-${var.cluster}")}"

  scheduling {
    on_host_maintenance = "MIGRATE"
    automatic_restart   = true
  }

  // create a boot image
  disk {
    source_image = "${var.disk_image}"
    auto_delete  = true
    boot         = true
  }

  // create an ephemeral image


  /*disk {*/


  /*auto_delete = true*/


  /*boot = false*/


  /*disk_size_gb = "${var.disk_size_gb}"*/


  /*disk_type = "${var.disk_type}"*/


  /*type = "${var.gce_disk_type}"*/


  /*mode = "READ_WRITE"*/


  /*}*/

  network_interface {
    subnetwork = "${element(var.zone_subnetworks, count.index)}"
  }
  metadata = {
    startup-script  = "${file(var.startup_script)}"
    region          = "${element(split("-", element(var.zones, count.index)), 0)}-${element(split("-", element(var.zones, count.index)), 1)}"
    cluster         = "${var.cluster}"
    zone            = "${element(var.zones, count.index)}"
    subnetwork_name = "${element(var.zone_subnetworks, count.index)}"
    infra           = "${var.infra}"
  }
}
