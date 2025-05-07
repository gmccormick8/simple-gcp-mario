output "instance_templates" {
  description = "The created instance templates"
  value       = google_compute_instance_template.templates
}

output "zonal_instance_groups" {
  description = "The created zonal instance groups"
  value       = google_compute_instance_group_manager.zonal
}

output "regional_instance_groups" {
  description = "The created regional instance groups"
  value       = google_compute_region_instance_group_manager.regional
}
