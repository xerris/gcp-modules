variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "project" {
  description = "the gcp project id"
  type        = string
}

variable "machine_type" {
  description = "the gcp machine type e.g. n1-medium, c2-medium"
  type        = string
  default     = "e2-medium"
}

variable "location" {
  description = "the gcp location"
  type        = string
  default     = "us-central1"
}

variable "min_node_count" {
  description = "the number of nodes in your worker pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "the number of nodes in your worker pool"
  type        = number
  default     = 1
}

variable "network_name" {
  default = "vpc-andromeda"
}

variable "version_gke" {
  default = "1.17.14-gke.400"
}

variable "cidr_range" {
  default = "10.1.0.0/16"
}

variable "cidr_range_2" {
  default = "192.168.10.0/24"
}

variable "subnet_name" {
  default = "sb-andromeda-prd"
}

variable "subnet_name_2" {
  default = "tf-test-secondary-range-update1"
}

variable "enable_private_nodes" {
  default = false
}

variable "enable_private_endpoint" {
  default = false
}

variable "cidr_master_range" {
  default = "10.3.0.0/28"
}
