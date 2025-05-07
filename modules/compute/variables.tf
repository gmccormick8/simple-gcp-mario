variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    name_prefix   = string
    machine_type  = string
    zone          = string
    region        = optional(string)
    target_size   = optional(number, 1)
    instance_type = optional(string, "zonal") # can be "zonal" or "regional"
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
  }))
}