# GCP Compute Engine Terraform Module

This module manages Google Compute Engine regional managed instance groups with auto-configured health checks and instance templates.

## Features

- Creates regional managed instance groups
- Configurable instance templates
- Automatic distribution across 3 zones in a region
- Built-in nginx web server installation
- OS Login enabled by default
- Configurable service account and network tags

## Usage

Basic usage example:

```hcl
module "compute" {
  source     = "./modules/compute"
  project_id = "my-project"

  instance = {
    name_prefix  = "web"
    machine_type = "e2-micro"
    region       = "us-central1"
    target_size  = 3
    boot_disk = {
      image = "debian-cloud/debian-12"
    }
    network_interface = {
      subnetwork = "default"
    }
    service_account = {
      email = "my-service-account@project.iam.gserviceaccount.com"
    }
    tags = ["http-server", "lb-web"]
  }
}
```

## Requirements

- Terraform >= 1.11.0
- Google Provider >= 6.30.0
- Google Project with necessary APIs enabled
  - compute.googleapis.com

## Inputs

| Name       | Description            | Type   | Required | Default |
| ---------- | ---------------------- | ------ | -------- | ------- |
| project_id | The GCP project ID     | string | yes      | -       |
| instance   | Instance configuration | object | yes      | -       |

### Instance Configuration

The `instance` variable supports the following attributes:

```hcl
instance = {
  name_prefix   = string               # Required: Prefix for instance names
  machine_type  = string               # Required: Machine type (e.g., "e2-micro")
  region        = string               # Required: Region for deployment
  target_size   = number               # Optional: Number of instances (default: 1)
  boot_disk = {
    image       = string               # Required: Boot disk image
    type        = string               # Optional: Disk type (default: "pd-standard")
    size        = number               # Optional: Disk size in GB (default: 50)
  }
  network_interface = {
    subnetwork  = string               # Required: Subnetwork self_link or name
    network_ip  = string               # Optional: Static internal IP
  }
  service_account = {                  # Optional: Service account configuration
    email       = string               # Optional: Service account email
    scopes      = list(string)         # Optional: Access scopes (default: ["cloud-platform"])
  }
  tags           = list(string)        # Optional: Network tags (default: [])
}
```

## Outputs

| Name              | Description                                          |
| ----------------- | ---------------------------------------------------- |
| instance_template | The created instance template resource               |
| instance_group    | The created regional instance group manager resource |

## Notes

- Instances are automatically distributed across three zones in the specified region
- Each instance runs nginx web server (installed via startup script)
- OS Login is enabled by default
- The module creates instance templates with a unique name prefix to support updates
