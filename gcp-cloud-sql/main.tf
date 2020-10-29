resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
  project = var.project

}
data "google_compute_network" "my-network" {
  name = var.network_name
  project = var.project
}

resource "google_sql_database_instance" "instance" {
  name   = var.db_name
  region = var.location
  database_version = "POSTGRES_11"
  project = var.project
  settings {
    tier = var.db_instance_type
    #ip_configuration {
    #  dynamic "authorized_networks" {
    #    for_each = var.authorized_networks
    #    iterator = onprem
#
    #    content {
    #      name  = "onprem-${onprem.key}"
    #      value = onprem.value
    #    }
    #  }
    #}
  }
}