variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "instance" {
  description = "Instance configuration options"
  type = object({
    name_prefix  = string
    machine_type = string
    region       = string
    min_replicas = number
    max_replicas = number
    boot_disk = object({
      image = string
      type  = string
      size  = number
    })
    network_interface = object({
      subnetwork = string
      network_ip = string
    })
    service_account = object({
      email  = string
      scopes = list(string)
    })
    tags = list(string)
  })

  validation {
    condition     = var.instance.min_replicas > 0
    error_message = "min_replicas must be greater than 0"
  }

  validation {
    condition     = var.instance.max_replicas >= var.instance.min_replicas
    error_message = "max_replicas must be greater than or equal to min_replicas"
  }

  default = {
    name_prefix  = null # Required - must be provided
    machine_type = null # Required - must be provided
    region       = null # Required - must be provided
    min_replicas = null # Required - must be provided
    max_replicas = null # Required - must be provided
    boot_disk = {
      image = null # Required - must be provided
      type  = "pd-standard"
      size  = 50
    }
    network_interface = {
      subnetwork = null # Required - must be provided
      network_ip = null
    }
    service_account = {
      email  = null
      scopes = ["cloud-platform"]
    }
    tags = []
  }
}
