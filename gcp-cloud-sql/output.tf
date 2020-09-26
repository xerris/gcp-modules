output "db-connection"{
    value = {
        self_link = google_sql_database_instance.instance.self_link
        connection_name = google_sql_database_instance.instance.connection_name
        database_self_link =  google_sql_database.database.self_link
        ip_address = google_sql_database_instance.instance.ip_address.0.ip_address

    }
}