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
    # Many thanks to anndcodes for this Mario game repo (https://github.com/anndcodes/mario-game.git)
    startup-script = <<-EOF
      #! /bin/bash
      apt-get update
      apt-get install -y apache2
      apt-get install -y git
      cd /var/www/html/
      rm -rf *
      git clone https://github.com/anndcodes/mario-game.git .
      service apache2 restart
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
  distribution_policy_zones = [
    "${var.instance.region}-a",
    "${var.instance.region}-b",
    "${var.instance.region}-c",
  ]

  named_port {
    name = "http"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.template.id
  }
}

# Create an auto-scaling policy for the instance group
resource "google_compute_region_autoscaler" "autoscaler" {
  name                = "${var.instance.name_prefix}-autoscaler"
  region              = var.instance.region
  target              = google_compute_region_instance_group_manager.regional.id
  autoscaling_policy {
    min_replicas = var.instance.min_replicas
    max_replicas = var.instance.max_replicas
    cpu_utilization {
      target = 0.8
    }
  }
  
}
