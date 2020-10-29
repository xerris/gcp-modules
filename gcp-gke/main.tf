locals {
    gke_compute_roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
       // "roles/stackdriver.resourceMetadata.write",
        "roles/storage.objectViewer"
    ]
}

resource "google_compute_network" "vpc_network" {
  name = var.network_name
  description = "A network to secure a large GKE cluster"
  auto_create_subnetworks = false
  project  = var.project
}

resource "google_compute_subnetwork" "private" {
  name          = var.subnet_name
  ip_cidr_range =   var.cidr_range #"10.1.0.0/16"
  region        = var.location
  project  = var.project
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = var.subnet_name_2
    ip_cidr_range = var.cidr_range_2 #"192.168.10.0/24"
  }
}

# service account for nodes

resource "google_service_account" "gke_compute_service_account" {
  project = var.project
  account_id   = "sa-${var.cluster_name}-compute"
  display_name = "${var.cluster_name} GKE Compute Service Account"
  description  = "provides access to basic compute for node pools"
}
resource "google_project_iam_member" "project_roles" {
  count   = length(local.gke_compute_roles)
  project = var.project
  role    = element(local.gke_compute_roles, count.index)
  member  = "serviceAccount:${google_service_account.gke_compute_service_account.email}"
}

data "google_compute_zones" "available" {
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project
  location = var.location
  min_master_version = var.version_gke
  network = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.private.name

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  initial_node_count       = 1
  node_locations = [data.google_compute_zones.available.names[0]]

  node_config {
    service_account = google_service_account.gke_compute_service_account.email
    machine_type = var.machine_type
    preemptible  = true
  }

 # private_cluster_config{
 #   enable_private_nodes = true
 #   enable_private_endpoint =  true
 #   master_ipv4_cidr_block = "10.3.0.0/28"
 # }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.cluster_name}-node-pool-1"
  project    = var.project
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    service_account = google_service_account.gke_compute_service_account.email

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  depends_on = [google_container_cluster.primary]
}
