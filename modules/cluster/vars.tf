variable "infra" {
  description = "parent infra name"
}

variable "name" {
  description = "cluster name"
}

variable "zones" {
  description = "list of zones that this cluster exists in"
  type        = "list"
}

variable "cidr_blocks_by_zone" {
  description = "map of cidr block ranges by zone"
  type        = "map"
}

variable "tcp_cluster_firewall" {
  description = "map of ports to open over tcp to other ports"
  type        = "map"
}

variable "udp_cluster_firewall" {
  description = "map of ports to open over udp to other ports"
  type        = "map"
}

variable "udp_range_firewall" {
  description = "map of cidr ranges to ports that should be open for them"
  default     = {}
}

variable "tcp_range_firewall" {
  description = "map of cidr ranges to ports that should be open for them"
  default     = {}
}

// internal variables
variable "_zones_to_region" {
  default = {
    "us-west1-a" = "us-west1"
    "us-west1-b" = "us-west1"

    "us-central1-a" = "us-central1"
    "us-central1-b" = "us-central1"
    "us-central1-c" = "us-central1"
    "us-central1-f" = "us-central1"

    "us-east1-b" = "us-east1"
    "us-east1-c" = "us-east1"
    "us-east1-d" = "us-east1"

    "europe-west1-b" = "europe-west1"
    "europe-west1-c" = "europe-west1"
    "europe-west1-d" = "europe-west1"

    "asia-east1-a" = "asia-east1"
    "asia-east1-b" = "asia-east1"
    "asia-east1-c" = "asia-east1"
  }
}
