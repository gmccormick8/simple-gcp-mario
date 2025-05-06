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
  cloud_nat_configs = ["us-central1"]
}

resource "google_service_account" "compute_engine_sa" {
  account_id   = "compute_engine_sa"
  display_name = "Service Account for Compute Engine"
}

resource "google_project_iam_binding" "compute_engine_sa_binding" {
  project = var.project_id
  role    = "roles/compute.imageUser, roles/compute.osAdminLogin"
  members = [
    "serviceAccount:${google_service_account.compute_engine_sa.email}",
  ]
}

module "compute" {
  source     = "./modules/compute"
  project_id = var.project_id

  instances = {
    "demo" = {
      name_prefix  = "demo"
      machine_type = "e2-micro"
      zone         = "us-central1-a"
      boot_disk = {
        image = "debian-cloud/debian-11"
      }
      network_interface = {
        subnetwork = module.network.subnets["prod-central-vpc"].self_link
      }
      service_account = {
        email  = google_service_account.compute_engine_sa.email
        scopes = ["cloud-platform"]
      }
      tags = ["demo"]
    }
  }
}