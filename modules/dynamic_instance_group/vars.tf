variable "infra" {
  description = "name of infra"
}

variable "cluster" {
  description = "cluster name that this scaling group belongs too"
}

variable "instances_per_zone" {
  description = "number of instances to create in each zone"
  default     = "1"
}

variable "instance_templates" {
  description = "list of instance self links by zone"
  type        = "list"
}

variable "zones" {
  description = "list of zones in which to create instances. (required)"
  type        = "list"
}

variable "max_per_zone" {
  description = "maximum instances per availability zone"
  default     = 2
}

variable "min_per_zone" {
  description = "minimum instances per availability zone"
  default     = 1
}

variable "cooldown_period" {
  description = "period to wait between changes"
  default     = 60
}

variable "cpu_utilization_target" {
  default = 0.5
}

variable "http_port_name" {
  default = "http"
}

variable "http_port_value" {
  default = 80
}

variable "https_port_name" {
  default = "https"
}

variable "https_port_value" {
  default = 443
}

variable "other_port_name" {
  default = "other"
}

variable "other_port_value" {
  default = 3500
}
