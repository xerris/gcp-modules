resource "google_dns_record_set" "record_set" {
  name         = var.dns_name
  managed_zone = var.dns_zone_name
  type         = var.type
  ttl          = 300
  project     = var.project
  rrdatas = var.record_data
}
