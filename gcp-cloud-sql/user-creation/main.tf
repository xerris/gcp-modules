
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "google_sql_user" "users" {
  name     = var.user_name
  instance = var.db_name
  project  = var.project
  password = random_password.password.result
}
