# Create instance templates
resource "google_compute_instance_template" "templates" {
  for_each = var.instances

  name_prefix  = "${each.value.name_prefix}-template-"
  machine_type = each.value.machine_type
  project      = var.project_id

  disk {
    source_image = each.value.boot_disk.image
    disk_type    = each.value.boot_disk.type
    disk_size_gb = each.value.boot_disk.size
    boot         = true
    auto_delete  = true
  }

  network_interface {
    subnetwork = each.value.network_interface.subnetwork
  }

  dynamic "service_account" {
    for_each = each.value.service_account != null ? [each.value.service_account] : []
    content {
      email  = service_account.value.email
      scopes = service_account.value.scopes
    }
  }

  tags = each.value.tags

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

# Create zonal instance groups
resource "google_compute_instance_group_manager" "zonal" {
  for_each = {
    for k, v in var.instances : k => v
    if lookup(v, "instance_type", "zonal") == "zonal"
  }

  name               = "${each.value.name_prefix}-igm"
  project            = var.project_id
  base_instance_name = each.value.name_prefix
  zone               = each.value.zone
  target_size        = each.value.target_size

  version {
    instance_template = google_compute_instance_template.templates[each.key].id
  }
}

# Create regional instance groups
resource "google_compute_region_instance_group_manager" "regional" {
  for_each = {
    for k, v in var.instances : k => v
    if lookup(v, "instance_type", "zonal") == "regional"
  }

  name               = "${each.value.name_prefix}-rigm"
  project            = var.project_id
  base_instance_name = each.value.name_prefix
  region             = each.value.region
  target_size        = each.value.target_size
  distribution_policy_zones = [
    "${each.value.region}-a",
    "${each.value.region}-b",
    "${each.value.region}-c",
  ]

  version {
    instance_template = google_compute_instance_template.templates[each.key].id
  }
}
