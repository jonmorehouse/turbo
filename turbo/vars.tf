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
