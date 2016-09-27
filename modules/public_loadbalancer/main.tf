resource "google_compute_target_http_proxy" "default" {
  name    = "${var.infra}-${var.name}"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_global_address" "default" {
  name = "${var.infra}-${var.name}"

  target          = "${google_compute_target_http_proxy}"
  default_service = "${google_compute_backend_service.default.self_link}"

  host_rule {
    hosts        = "${var.hostnames}"
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = "${google_compute_backend_service.default.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.default.self_link}"
    }
  }
}

resource "google_compute_backend_service" "default" {
  name          = "default-backend"
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = ["${google_compute_http_health_check.default.self_link}"]

  backend {
    group = "${var.instance_group}"
  }
}
