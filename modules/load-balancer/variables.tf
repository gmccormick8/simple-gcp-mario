variable "mig_group" {
  description = "Backend Service Managed Instance Group"
  type = object({ })
}

variable "region" {
  description = "Region for the load balancer"
  type        = string
}


