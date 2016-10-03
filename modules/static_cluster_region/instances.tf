// create a deterministic total number of instances, which correspond to the
// number of instances per zone for this cluster, times the total number of
// zones
resource "google_compute_instance" "default" {
  // this creates n instances per zone, in the order [zonea-0, zonea-1, zonea-2, zoneb-0, zoneb-1, zoneb-2]
  count = "${length(compact(var.zones)) * var.instances_per_zone}"

  // infra-name-regionOffset-zone-zoneOffset
  name = "${var.parent_id}-${element(var.zones, (count.index / var.instances_per_zone) % length(var.zones))}-${count.index % var.instances_per_zone}"

  machine_type   = "${var.machine_type}"
  zone           = "${element(var.zones, count.index % var.instances_per_zone)}"
  can_ip_forward = true

  tags = "${list(
            "parent-${var.parent_id}",
            "zone-${element(var.zones, count.index % var.instances_per_zone)}"
          )}"

  disk {
    image       = "${var.disk_image}"
    auto_delete = true
  }

  metadata_startup_script = "${var.startup_script}"

  network_interface {
    // network is created by the cluster module, and is formatted via name: parent_id-zone
    subnetwork = "${element(google_compute_subnetwork.default.*.name, (count.index / var.instances_per_zone) % length(var.zones))}"

    // the ip address inside of the subnetwork is deterministic and corresponds to its offset in the cidr block.
    address = "${cidrhost(lookup(var.cidr_blocks_by_zone, element(var.zones, (count.index / var.instances_per_zone) % length(var.zones))), (count.index % var.instances_per_zone) + 2)}"

    access_config {
      // NOTE: by _not_ specifying a nat_ip, this block is granted a dynamic,
      // address that is auto generated and publicly accessible.
    }
  }
}

