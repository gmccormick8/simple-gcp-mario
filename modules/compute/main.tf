locals {
  instances_flat = flatten([
    for k, v in var.instances : [
      for i in range(v.instance_count) : {
        key               = k
        name              = "${v.name_prefix}-${i + 1}"
        machine_type      = v.machine_type
        zone              = v.zone
        boot_disk         = v.boot_disk
        network_interface = v.network_interface
        service_account   = v.service_account
        tags              = v.tags
      }
    ]
  ])
}

resource "google_compute_instance" "instances" {
  for_each = { for inst in local.instances_flat : inst.name => inst }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone
  project      = var.project_id

  hostname = "${each.value.name}@example.com"

  boot_disk {
    initialize_params {
      image = each.value.boot_disk.image
      type  = each.value.boot_disk.type
      size  = each.value.boot_disk.size
    }
  }

  network_interface {
    subnetwork = each.value.network_interface.subnetwork
    network_ip = each.value.network_interface.network_ip
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
  }
}
