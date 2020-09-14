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

variable "node_count" {
  description = "the number of nodes in your worker pool"
  type        = number
  default     = 1
}
