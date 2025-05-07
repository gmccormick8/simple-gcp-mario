# GCP HTTP Load Balancer Terraform Module

This module creates a Google Cloud Platform HTTP Load Balancer with regional backend services.

## Features

- Creates an external HTTP load balancer
- Configures regional backend services
- Sets up health checks
- Provisions static IP address
- Establishes forwarding rules

## Usage

Basic usage example:

```hcl
module "load-balancer" {
  source    = "./modules/load-balancer"
  region    = "us-central1"
  mig_group = module.compute.regional_instance_groups["app"]
}
```

## Requirements

- Terraform >= 1.11.0
- Google Provider >= 6.30.0
- A configured managed instance group to serve as backend

## Inputs

| Name      | Description                            | Type   | Required |
| --------- | -------------------------------------- | ------ | -------- |
| region    | Region for the load balancer           | string | yes      |
| mig_group | Backend Service Managed Instance Group | object | yes      |

## Outputs

| Name             | Description                                  |
| ---------------- | -------------------------------------------- |
| load_balancer_ip | The external IP address of the load balancer |

## Resources Created

- Static IP Address
- Regional Backend Service
- Health Check
- URL Map
- Target HTTP Proxy
- Global Forwarding Rule

## Notes

- The module configures HTTP (port 80) load balancing
- Health checks are performed every 5 seconds
- Backend timeout is set to 10 seconds
