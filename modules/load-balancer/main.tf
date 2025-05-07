#Reserve a static IP address for the load balancer
resource "google_compute_global_address" "lb-ip" {
  name         = "lb-ip"
  address_type = "EXTERNAL"
}

#Create a backend service for the load balancer
resource "google_compute_region_backend_service" "backend" {
  name                  = "website-backend"
  region                = var.region
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group          = var.mig_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

#Create a health check for the backend service
resource "google_compute_region_health_check" "default" {
  name               = "http-health-check"
  region             = var.region
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

#Create a URL map for the load balancer
resource "google_compute_region_url_map" "url-map" {
  name            = "http-lb"
  region = var.region
  default_service = google_compute_region_backend_service.backend.id
}

#Create a target HTTP proxy for the load balancer
resource "google_compute_region_target_http_proxy" "http-proxy" {
  name    = "http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.url-map.id
}

#Create a global forwarding rule
resource "google_compute_global_forwarding_rule" "forwarding-rule" {
  name                  = "website-forwarding-rule"
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_region_target_http_proxy.http-proxy.id
  ip_address            = google_compute_global_address.lb-ip.id
}
