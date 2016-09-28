// number of instances per zone in the coordination cluster
variable "coordination_instances_per_zone" {
  default = 1
}

variable "coordination_failover_zones" {
  description = "map of zones to their failover zones. Each zone does _not_
  require a failover zone"
  default = {}
}

variable "coordination_zones" {
  description = "zones that should exist per region in the cluster. Note,
      failover is ordered between zones in a cluster based on this order."

  default = {
    "us-west1"     = "us-west1-a,us-west1-b"
    "us-central1"  = "us-central1-a,us-central1-b,us-central1-c,us-central1-f"
    "us-east1"     = "us-east1-b,us-east1-c,us-east1-d"
    "europe-west1" = "europe-west1-b,europe-west1-c,europe-west1-d"
    "asia-east1"   = "asia-east1-a,asia-east1-b,asia-east1-c"
  }
}

variable "coordination_failover_zones" {
  description = "zones which the primary zones failover too. Each backup pool
  is created as its own target pool and and linked to the primary pool to
  receive failover traffic when the primary is unhealthy"
  type = "map"
}

// cidr block ranges per zone in the coordination cluster
variable "coordination_cidr_blocks_by_zone" {
  description = "Mapping of cidr block ranges by zone. Turbo is configured by default so that you don't need to override these cidr blocks, regardless of the zones being used."
  type        = "map"

  default = {
    "us-west1-a" = "10.0.0.0/16"
    "us-west1-b" = "10.1.0.0/16"

    "us-central1-a" = "10.2.0.0/16"
    "us-central1-b" = "10.3.0.0/16"
    "us-central1-c" = "10.4.0.0/16"
    "us-central1-f" = "10.5.0.0/16"

    "us-east1-b" = "10.6.0.0/16"
    "us-east1-c" = "10.7.0.0/16"
    "us-east1-d" = "10.8.0.0/16"

    "europe-west1-b" = "10.9.0.0/16"
    "europe-west1-c" = "10.10.0.0/16"
    "europe-west1-d" = "10.11.0.0/16"

    "asia-east1-a" = "10.12.0.0/16"
    "asia-east1-b" = "10.13.0.0/16"
    "asia-east1-c" = "10.14.0.0/16"
  }
}

// firewall configurations
variable "coordination_tcp_cluster_firewall" {
  default = {}
}

variable "coordination_udp_cluster_firewall" {
  default = {}
}

variable "coordination_tcp_range_firewall" {
  default = {}
}

variable "coordination_udp_range_firewall" {
  default = {}
}

// provisioner configurations / startup scripts
variable "coordination_startup_script" {
  description = "Startup script path. This script is set as the metadata
  startup script on each new instance configured."
}

variable "coordination_bootstrap_script" {
  description = "Bootstrap script path. Bootstrap scripts are run after a
  region's instances have been bootstrapped and is responsible for doing things
  such as bootstrapping a cluster. This is run on a single arbitrary host per
  region."
}
