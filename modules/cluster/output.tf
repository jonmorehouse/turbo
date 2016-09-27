// regions is a list of the distinct regions which this cluster presides in
output "regions" {
  value = "${list("hi")}"
}

output "zone_names" {
  value = "${list(google_compute_subnetwork.default.*.name)}"
}

output "zone_links" {
  value = "${list(google_compute_subnetwork.default.*.self_link)}"
}

output "infra" {
  value = "${var.infra}"
}

output "name" {
  value = "${var.name}"
}

output "id" {
  value = "${var.infra}-${var.name}"
}
