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
      type  = optional(string, "pd-standard")
      size  = optional(number, 50)
    })
    network_interface = object({
      subnetwork = string
      network_ip = optional(string)
    })
    service_account = optional(object({
      email  = optional(string)
      scopes = optional(list(string), ["cloud-platform"])
    }))
    tags = optional(list(string), [])
  })
}
