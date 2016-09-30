variable "name" {
  description = "infra name"
}

variable "disk_image" {
  default = "coreos-cloud/coreos-stable"
}

// zone_subnetworks defines cidr ranges for each unique zone within each region
variable "zone_subnetwork_cidr_blocks" {
  description = "mapping of subnetworks to each unique zone "
  type        = "map"

  default = {
    "us-west1-a" = "10.0.1.0/24"
    "us-west1-b" = "10.0.2.0/24"

    "us-central1-a" = "10.0.3.0/24"
    "us-central1-b" = "10.0.4.0/24"
    "us-central1-c" = "10.0.5.0/24"
    "us-central1-f" = "10.0.6.0/24"

    "us-east1-b" = "10.0.7.0/24"
    "us-east1-c" = "10.0.8.0/24"
    "us-east1-d" = "10.0.9.0/24"

    "europe-west1-b" = "10.0.10.0/24"
    "europe-west1-c" = "10.0.11.0/24"
    "europe-west1-d" = "10.0.12.0/24"

    "asia-east1-a" = "10.0.13.0/24"
    "asia-east1-b" = "10.0.14.0/24"
    "asia-east1-c" = "10.0.15.0/24"
  }
}

// core cluster ports to open over udp by source cluster
variable "core_udp_port_configuration" {
  description = "UDP port/port-ranges to open, by cluster, to the core cluster."

  default = {
    coordination = "8000"
    service      = "8000"
    public       = "8000"
    bastion      = ""
  }
}

// core cluster ports to open over tcp by source cluster
variable "core_tcp_port_configuration" {
  description = "TCP port/port-ranges to open, by cluster, to the core cluster."

  default = {
    coordination = "8000"
    service      = "8000"
    public       = "8000"
    bastion      = "22"
  }
}

// service cluster ports to open over udp by source cluster
variable "service_udp_port_configuration" {
  description = "UDP port/port-ranges to open, by cluster, to the service cluster."

  default = {
    coordination = "8000"
    service      = "8000"
    public       = "8000"
    bastion      = ""
  }
}

// service cluster ports to open over tcp by source cluster
variable "service_tcp_port_configuration" {
  description = "TCP port/port-ranges to open, by cluster, to the service cluster."

  default = {
    coordination = "8000"
    service      = "8000"
    public       = "8000"
    bastion      = "22"
  }
}

// public cluster ports to open over udp by source cluster
variable "public_udp_port_configuration" {
  description = "UDP port/port-ranges to open, by cluster, to the public cluster."

  default = {
    coordination = ""
    service      = ""
    public       = ""
    bastion      = ""
  }
}

// public cluster ports to open over tcp by source cluster
variable "public_tcp_port_configuration" {
  description = "TCP port/port-ranges to open, by cluster, to the public cluster."

  default = {
    coordination = ""
    service      = ""
    public       = ""
    bastion      = "22"
  }
}

// bastion cluster ports to open over udp by source cluster
variable "bastion_udp_port_configuration" {
  description = "UDP port/port-ranges to open, by cluster, to the bastion cluster."

  default = {
    coordination = ""
    service      = ""
    public       = ""
    bastion      = ""
  }
}

// bastion cluster ports to open over tcp by source cluster
variable "bastion_tcp_port_configuration" {
  description = "TCP port/port-ranges to open, by cluster, to the bastion cluster."

  default = {
    coordination = ""
    service      = ""
    public       = ""
    bastion      = ""
  }
}
