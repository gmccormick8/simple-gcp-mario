# GCP Compute Engine Terraform Module

This module manages Google Compute Engine instances.

## Features

- Creates multiple compute instances
- Configurable machine types and boot disks
- Network interface configuration
- Service account attachment
- Instance tagging support

## Usage

Basic usage:

```hcl
module "compute" {
  source     = "./modules/compute"
  project_id = "my-project"

  instances = {
    "app" = {
      name_prefix  = "app"
      machine_type = "e2-medium"
      zone         = "us-central1-a"
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
- `zone` - The zone where the instance will be created
- `instance_count` - Number of instances (default: 1)
- `boot_disk` - Boot disk configuration
- `network_interface` - Network interface configuration
- `service_account` - Service account configuration (optional)
- `tags` - List of network tags (optional)

## Outputs

| Name         | Description                            |
| ------------ | -------------------------------------- |
| instances    | The created compute instances          |
| instance_ips | Internal IP addresses of the instances |
