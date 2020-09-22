variable "project" {
  description = "the gcp project id"
  type        = string
}

variable "apis"{
    description = "API list to activate"
    type    = list(string)
}