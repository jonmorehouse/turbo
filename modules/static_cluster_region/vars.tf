variable "parent_id" {
  description = "parent cluster's id"
}

variable "region" {}

variable "zones" {
  type = "list"
}

variable "failover_zones" {
  type = "map"
}

variable "failover_ratio" {
  description = "ratio of failed instances before failing over to the backup pool"
  default = 0.8
}

variable "instances_per_zone" {
  default = "1"
}

variable "backup_target_pools_by_zone" {
  description = "map of which zones failover to which other zones. If a zone is
  not specified it does not failover"
  type = "map"
  default = {}
}

variable "cidr_blocks_by_zone" {
  description = "map of zones to their respective cidr blocks"
  type        = "map"
}

// instance configuration
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
  default = "coreos-cloud/coreos-stable"
}

variable "startup_script" {
  description = "path of the startup script that should be written as the
      startup-script."

  default = "/dev/null"
}

variable "_int_to_sequence" {
  description = "A map of comma delimited integers in a series. This is a hack,
      to make the api to this module nicer until terraform supports the ability to
      dynamically generate a sequence"

  default = {
    "0"  = ""
    "1"  = "0"
    "2"  = "0,1"
    "3"  = "0,1,2"
    "4"  = "0,1,2,3"
    "5"  = "0,1,2,3,4"
    "6"  = "0,1,2,3,4,5"
    "7"  = "0,1,2,3,4,5,6"
    "8"  = "0,1,2,3,4,5,6,7"
    "9"  = "0,1,2,3,4,5,6,7,8"
    "10" = "0,1,2,3,4,5,6,7,8,9"
  }
}
