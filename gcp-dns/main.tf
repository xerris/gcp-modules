resource "google_dns_managed_zone" "project-zone" {
  name        = var.zone_name
  dns_name    = var.dns_name
  description = "${var.dns_name} DNS zone"
  project     = var.project
}