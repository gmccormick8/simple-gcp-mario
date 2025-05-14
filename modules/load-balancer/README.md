# GCP HTTP Load Balancer Terraform Module

This module creates a Google Cloud Platform Global HTTP Load Balancer with external managed backend services.

## Features

- Creates an external global HTTP load balancer
- Configures managed backend services
- Sets up HTTP health checks
- Provisions static external IP address
- Establishes global forwarding rules

## Usage

Basic usage example:

```hcl
module "load-balancer" {
  source    = "./modules/load-balancer"
  mig_group = module.compute.instance_group_url
}
```

## Requirements

- Terraform >= 1.11
- Google Provider >= 6.30
- A configured managed instance group to serve as backend

## Inputs

| Name      | Description                               | Type   | Required |
| --------- | ----------------------------------------- | ------ | -------- |
| mig_group | URL of the managed instance group backend | string | yes      |

## Outputs

| Name             | Description                                  |
| ---------------- | -------------------------------------------- |
| load_balancer_ip | The external IP address of the load balancer |

## Resources Created

- Global external IP address (`google_compute_global_address`)
- Backend service with health checks (`google_compute_backend_service`)
- HTTP health check (`google_compute_health_check`)
- URL map (`google_compute_url_map`)
- Target HTTP proxy (`google_compute_target_http_proxy`)
- Global forwarding rule (`google_compute_global_forwarding_rule`)

## Load Balancer Configuration

- Uses global HTTP load balancing (not regional)
- Health checks:
  - HTTP on port 80
  - 5 second check interval
  - 5 second timeout
- Backend service:
  - HTTP protocol
  - 10 second timeout
  - UTILIZATION balancing mode
  - 100% capacity (capacity_scaler = 1.0)
- Frontend:
  - HTTP on port 80
  - External managed load balancing scheme
