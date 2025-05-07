# GCP Compute Engine Terraform Module

This module manages Google Compute Engine instance groups.

## Features

- Creates managed instance groups (both zonal and regional)
- Configurable instance templates
- Supports auto-scaling configurations
- Network interface configuration
- Service account attachment
- Instance tagging support

## Usage

Basic usage with zonal instance group:

```hcl
module "compute" {
  source     = "./modules/compute"
  project_id = "my-project"

  instances = {
    "app" = {
      name_prefix  = "app"
      machine_type = "e2-medium"
      zone         = "us-central1-a"
      target_size  = 3
      boot_disk = {
        image = "debian-cloud/debian-11"
      }
      network_interface = {
        subnetwork = "default"
      }
      tags = ["app", "web"]
    }
  }
}
```

Regional instance group example:

```hcl
module "compute" {
  source     = "./modules/compute"
  project_id = "my-project"

  instances = {
    "app-regional" = {
      name_prefix    = "app"
      machine_type   = "e2-medium"
      region         = "us-central1"
      instance_type  = "regional"  # Specify regional deployment
      target_size    = 6
      boot_disk = {
        image = "debian-cloud/debian-11"
      }
      network_interface = {
        subnetwork = "default"
      }
      tags = ["app", "web"]
    }
  }
}
```

## Inputs

| Name       | Description                    | Type        | Required |
| ---------- | ------------------------------ | ----------- | -------- |
| project_id | The GCP project ID             | string      | yes      |
| instances  | Map of instance configurations | map(object) | yes      |

### Instance Configuration

Each instance configuration supports the following attributes:

- `name_prefix` - Prefix for the instance name
- `machine_type` - The machine type
- `zone` - The zone for zonal instance groups
- `region` - The region for regional instance groups
- `instance_type` - Either "zonal" or "regional" (default: "zonal")
- `target_size` - Number of instances to maintain (default: 1)
- `boot_disk` - Boot disk configuration
- `network_interface` - Network interface configuration
- `service_account` - Service account configuration (optional)
- `tags` - List of network tags (optional)

## Outputs

| Name                     | Description                          |
| ------------------------ | ------------------------------------ |
| instance_templates       | The created instance templates       |
| zonal_instance_groups    | The created zonal instance groups    |
| regional_instance_groups | The created regional instance groups |
