variable "db_name" {}
variable "project" {}
variable "db_instance_type" {
  default = "db-f1-micro"
}
variable "authorized_networks" {
  type    = list
  default = [""]
}

variable "network_name" {
  default = "vpc-andromeda"
}

variable "location" {
  default = "us-central1"
}