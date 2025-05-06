output "instances" {
  description = "The created compute instances"
  value       = google_compute_instance.instances
}

output "instance_ips" {
  description = "Internal IP addresses of the instances"
  value = {
    for name, instance in google_compute_instance.instances : name => instance.network_interface[0].network_ip
  }
}
