output "instance_template" {
  description = "The created instance templates"
  value       = google_compute_instance_template.template
}

output "instance_group" {
  description = "The created regional instance group"
  value       = google_compute_region_instance_group_manager.regional
}
