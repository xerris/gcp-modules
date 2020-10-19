provider "google" {
  #credentials = file("~/.config/gcloud/terraform.json")
  version     = "3.5.0"
  region      = var.region
  project     = var.project
}

provider "google-beta" {
  #credentials = file("~/.config/gcloud/terraform.json")
  version     = "3.5.0"
  region      = var.region
  project     = var.project
}

# ------------------------------------------------------------------------------
# CREATE A STORAGE BUCKET
# ------------------------------------------------------------------------------

resource "google_storage_bucket" "cdn_bucket" {
  name          = var.bucket_name
  storage_class = "MULTI_REGIONAL"
  location      = var.location # You might pass this as a variable
  project       = var.project
}

# ------------------------------------------------------------------------------
# CREATE A BACKEND CDN BUCKET
# ------------------------------------------------------------------------------

resource "google_compute_backend_bucket" "cdn_backend_bucket" {
  name        = var.cdn_bucket_name
  description = "Backend bucket for serving static content through CDN"
  bucket_name = google_storage_bucket.cdn_bucket.name
  enable_cdn  = true
  project     = var.project
}

# ------------------------------------------------------------------------------
# CREATE A URL MAP
# ------------------------------------------------------------------------------

resource "google_compute_url_map" "cdn_url_map" {
  name            = var.cdn_url_map
  description     = "CDN URL map to cdn_backend_bucket"
  default_service = google_compute_backend_bucket.cdn_backend_bucket.self_link
  project         = var.project
}


resource "google_compute_managed_ssl_certificate" "cdn_certificate" {
  provider = google-beta
  project  = var.project

  name = var.certificate_name

  managed {
    domains = [var.domain_name]
  }
}

# ------------------------------------------------------------------------------
# CREATE HTTPS PROXY
# ------------------------------------------------------------------------------

resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  name             = "cdn-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_certificate.self_link]
  project          = var.project
}

# ------------------------------------------------------------------------------
# CREATE A GLOBAL PUBLIC IP ADDRESS
# ------------------------------------------------------------------------------

resource "google_compute_global_address" "cdn_public_address" {
  name         = var.public_address_name
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
  project      = var.project
}

# ------------------------------------------------------------------------------
# CREATE A GLOBAL FORWARDING RULE
# ------------------------------------------------------------------------------

resource "google_compute_global_forwarding_rule" "cdn_global_forwarding_rule" {
  name       = var.global_fw_rule
  target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
  ip_address = google_compute_global_address.cdn_public_address.address
  port_range = "443"
  project    = var.project
}

# ------------------------------------------------------------------------------
# CREATE DNS RECORD
# ------------------------------------------------------------------------------

resource "google_dns_record_set" "cdn_dns_a_record" {
  managed_zone = var.managed_zone # Name of your managed DNS zone
  name         = var.domain_name
  type         = "A"
  ttl          = 3600 # 1 hour
  rrdatas      = [google_compute_global_address.cdn_public_address.address]
  project      = var.project
}

# ------------------------------------------------------------------------------
# MAKE THE BUCKET PUBLIC
# ------------------------------------------------------------------------------

resource "google_storage_bucket_iam_member" "all_users_viewers" {
  bucket = google_storage_bucket.cdn_bucket.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}