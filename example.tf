provider "google" {
  project = "foo"
  region  = "us-east1"
}

module "example_infra" {
  source = "./turbo"
  name   = "example"

  coordination_instances_per_zone = 1

  coordination_zones = {
    "us-west1" = "us-west1-a,us-west1-b"
    "us-central1" = "us-central1-a"
  }

  coordination_failover_zones = {
    "us-west1-a" = "us-west1-b"
    "us-west1-b" = "us-west1-a"
  }
}

output "debug" {
  value = "${module.example_infra.debug}"
}
