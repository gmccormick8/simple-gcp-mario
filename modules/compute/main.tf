# Create an instance template
resource "google_compute_instance_template" "template" {

  name_prefix  = "${var.instance.name_prefix}-template"
  machine_type = var.instance.machine_type
  project      = var.project_id

  disk {
    source_image = var.instance.boot_disk.image
    disk_type    = var.instance.boot_disk.type
    disk_size_gb = var.instance.boot_disk.size
    boot         = true
    auto_delete  = true
  }

  network_interface {
    subnetwork = var.instance.network_interface.subnetwork
  }

  service_account {
    email  = var.instance.service_account.email
    scopes = var.instance.service_account.scopes
  }

  tags = var.instance.tags

  metadata = {
    enable-oslogin = "TRUE"
    startup-script = <<-EOF
      #! /bin/bash
      apt-get update
      apt-get install -y nginx
      service nginx start
    EOF
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a regional instance group
resource "google_compute_region_instance_group_manager" "regional" {
  name               = "${var.instance.name_prefix}-rigm"
  project            = var.project_id
  base_instance_name = var.instance.name_prefix
  region             = var.instance.region
  target_size        = var.instance.target_size
  distribution_policy_zones = [
    "${var.instance.region}-a",
    "${var.instance.region}-b",
    "${var.instance.region}-c",
  ]

  version {
    instance_template = google_compute_instance_template.template.id
  }
}
