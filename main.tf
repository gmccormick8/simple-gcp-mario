# Create a VPC network and subnet
module "network" {
  source       = "./modules/network"
  project_id   = var.project_id
  network_name = "prod"

  subnets = {
    "prod-central-vpc" = {
      region = "us-central1"
      cidr   = "10.0.0.0/24"
    }
  }

  firewall_rules = {
    "allow-inbound-iap-ssh-access" = {
      direction     = "INGRESS"
      source_ranges = ["35.235.240.0/20"]
      target_tags   = ["http-server"]
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    }
    "allow-inbound-http-access" = {
      direction     = "INGRESS"
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["http-server"]
      allow = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
    }
  }

  cloud_nat_configs = ["us-central1"]
}

# Create a Service Account for Compute Engine
resource "google_service_account" "compute-engine-sa" {
  account_id   = "compute-engine-sa"
  display_name = "Service Account for Compute Engine"
}


# Assign IAM roles to the service account
# Thanks to intotech for this idea https://stackoverflow.com/a/71521532
resource "google_project_iam_member" "compute_engine_sa_binding" {
  for_each = toset([
    "roles/compute.imageUser",
    "roles/compute.osAdminLogin"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.compute-engine-sa.email}"
}

# Create a Compute Engine Managed Instance Group
module "compute" {
  source     = "./modules/compute"
  project_id = var.project_id

  instance = {
    name_prefix  = "mario"
    machine_type = "e2-micro"
    region       = "us-central1"
    target_size  = 3
    boot_disk = {
      image = "debian-cloud/debian-12"
    }
    network_interface = {
      subnetwork = module.network.subnets["prod-central-vpc"].self_link
    }
    service_account = {
      email  = "${google_service_account.compute-engine-sa.email}"
      scopes = ["cloud-platform"]
    }
    tags = ["http-server"]
  }
}

# Create a load balancer for the website
module "load-balancer" {
  source    = "./modules/load-balancer"
  mig_group = module.compute.instance_group.instance_group
}
