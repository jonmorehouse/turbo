variable "public_max_instances_per_zone" {
  description = "maximum number of instances that can be configured per zone"

  default = {
    "us-west1-a" = 0
    "us-west1-b" = 0

    "us-central1-a" = 0
    "us-central1-b" = 0
    "us-central1-c" = 0
    "us-central1-f" = 0

    "us-east1-b" = 0
    "us-east1-c" = 0
    "us-east1-d" = 0

    "europe-west1-b" = 0
    "europe-west1-c" = 0
    "europe-west1-d" = 0

    "asia-east1-a" = 0
    "asia-east1-b" = 0
  }
}

variable "public_min_instances_per_zone" {
  description = "maximum number of instances that can be configured per zone"

  default = {
    "us-west1-a" = 0
    "us-west1-b" = 0

    "us-central1-a" = 0
    "us-central1-b" = 0
    "us-central1-c" = 0
    "us-central1-f" = 0

    "us-east1-b" = 0
    "us-east1-c" = 0
    "us-east1-d" = 0

    "europe-west1-b" = 0
    "europe-west1-c" = 0
    "europe-west1-d" = 0

    "asia-east1-a" = 0
    "asia-east1-b" = 0
  }
}
