output "ids" {
  value = "${concat(google_compute_instance_template.default.*.id)}"
}

output "names" {
  value = "${concat(google_compute_instance_template.default.*.name)}"
}

output "self_links" {
  value = "${concat(google_compute_instance_template.default.*.self_link)}"
}
