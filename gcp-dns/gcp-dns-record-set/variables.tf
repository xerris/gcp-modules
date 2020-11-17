variable "dns_name" {}
variable "dns_zone_name" {}
variable "type" {}
variable "project" {}
variable "record_data" {
  type = list(string)
}