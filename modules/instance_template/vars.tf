variable "infra" {
  description = "infra is the parent infrastructure cluster. This denotes the
      parent network that encompasses all clusters and is used as meta data on the
      instance template. (required)"

  type = "string"
}

variable "cluster" {
  description = "cluster name that this instance template belongs too. (required)"

  type = "string"
}

variable "zones" {
  description = "instance templates are created in each unique zone, because
      we'd like to control the subnetwork that an instance template uses and those
      are zone specific"

  type = "list"
}

variable "zone_subnetworks" {
  description = "each instance template is attached to a network interface
      which corresponds to a specific zone's subnetwork."

  type = "list"
}

variable "machine_type" {
  description = "Machine type of the instance to use"

  type    = "string"
  default = "f1-micro"
}

variable "disk_image" {
  description = "Disk image to use for this instance. See:
      https://cloud.google.com/compute/docs/images#image_families. (default:
      coreos/coreos-stable)"

  type    = "string"
  default = "coreos/coreos-stable"
}

variable "disk_size_gb" {
  type        = "string"
  description = "size of the secondary disk to be created"
  default     = 10
}

variable "disk_type" {
  type        = "string"
  description = "disk type one of pd-ssd|local-ssd|pd-standard"
  default     = "pd-standard"
}

variable "gce_disk_type" {
  type        = "string"
  description = "gce disk type one of PERSISTENT|SCRATCH"
  default     = "SCRATCH"
}

variable "startup_script" {
  description = "path of the startup script that should be written as the
      startup-script."

  default = "/dev/null"
}
