variable "labels"{
    type = list
    default = [""]
}

variable "name"{}
variable "namespace"{}
variable "replicas"{
    default = 1
}
variable "image"{}
variable "container_port"{}
variable "cpu_limit"{}
variable "memory_limit"{}
variable "cpu_request"{}
variable "memory_limit"{}