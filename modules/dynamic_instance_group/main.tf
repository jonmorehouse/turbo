resource "google_compute_target_pool" "default" {
  name = "${var.infra}-${var.cluster}"
}

resource "google_compute_instance_group_manager" "default" {
  count = "${length(var.zones)}"

  name = "${var.infra}-${var.cluster}-${element(var.zones, count.index)}"
  zone = "${element(var.zones, count.index)}"

  instance_template  = "${element(var.instance_templates, count.index)}"
  base_instance_name = "${var.infra}-${var.cluster}-${element(var.zones, count.index)}"

  named_port {
    name = "${var.http_port_name}"
    port = "${var.http_port_value}"
  }

  named_port {
    name = "${var.https_port_name}"
    port = "${var.https_port_value}"
  }

  named_port {
    name = "${var.other_port_name}"
    port = "${var.other_port_value}"
  }
}

resource "google_compute_autoscaler" "default" {
  count = "${length(var.zones)}"

  name = "${var.infra}-${var.cluster}-${element(var.zones, count.index)}"
  zone = "${element(var.zones, count.index)}"

  target = "${element(concat(google_compute_instance_group_manager.default.*.self_link), count.index)}"

  autoscaling_policy = {
    max_replicas    = "${var.max_per_zone}"
    min_replicas    = "${var.min_per_zone}"
    cooldown_period = "${var.cooldown_period}"

    cpu_utilization {
      target = "${var.cpu_utilization_target}"
    }
  }
}
