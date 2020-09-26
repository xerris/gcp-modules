output "db-user"{
    value = {
        username = google_sql_user.users.name
        password = google_sql_user.users.password
    }
}