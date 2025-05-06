# GCP Network Terraform Module

This module creates a Google Cloud Platform VPC network with associated resources including subnets, Cloud NAT, Cloud Router, and firewall rules.

## Features

- Creates a custom mode VPC network
- Supports multiple subnet configurations
- Configures Cloud NAT and Cloud Router for internet egress
- Flexible firewall rule management
- Supports global or regional routing modes

## Usage

Basic usage with a single subnet:

```hcl
module "network" {
  source       = "./modules/network"
  project_id   = "my-project"
  network_name = "my-vpc"
  
  subnets = {
    "subnet-1" = {
      region = "us-central1"
      cidr   = "10.0.0.0/24"
    }
  }
}
```

Advanced usage with multiple subnets, firewall rules, and Cloud NAT:

```hcl
module "network" {
  source       = "./modules/network"
  project_id   = "my-project"
  network_name = "my-vpc"
  routing_mode = "REGIONAL"
  
  subnets = {
    "subnet-us-central" = {
      region = "us-central1"
      cidr   = "10.0.1.0/24"
    }
    "subnet-us-east" = {
      region = "us-east1"
      cidr   = "10.0.2.0/24"
    }
  }
  
  firewall_rules = {
    "allow-internal" = {
      direction     = "INGRESS"
      source_ranges = ["10.0.0.0/8"]
      allow = [{
        protocol = "tcp"
        ports    = ["0-65535"]
      }]
    }
    "allow-health-checks" = {
      direction     = "INGRESS"
      source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
      }]
    }
  }
  
  cloud_nat_configs = ["us-central1", "us-east1"]
}
```

## Requirements

- Terraform >= 1.0
- Google Provider >= 4.0
- Google Project with necessary APIs enabled
  - compute.googleapis.com
  - servicenetworking.googleapis.com

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| project_id | The GCP project ID | string | yes | - |
| network_name | The name of the network | string | yes | - |
| routing_mode | The network routing mode (GLOBAL or REGIONAL) | string | no | "GLOBAL" |
| subnets | Map of subnet configurations | map(object) | no | {} |
| firewall_rules | Map of firewall rules | map(object) | no | {} |
| cloud_nat_configs | Regions where Cloud NAT should be configured | set(string) | no | [] |

### Subnet Configuration

The `subnets` variable expects a map of objects with the following structure:

```hcl
subnets = {
  "subnet-name" = {
    region = string
    cidr   = string
  }
}
```

### Firewall Rule Configuration

The `firewall_rules` variable expects a map of objects with the following structure:

```hcl
firewall_rules = {
  "rule-name" = {
    direction     = string
    priority      = number (optional)
    source_ranges = list(string) (optional)
    target_tags   = list(string) (optional)
    allow = list(object({
      protocol = string
      ports    = list(string) (optional)
    }))
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| network | The created network resource |
| network_id | The ID of the VPC |
| network_self_link | The URI of the VPC |
| subnets | Map of created subnet resources |
| subnet_ids | Map of subnet IDs |

## License

This module is licensed under the GNU General Public License v3.0
