resource "null_resource" "ambassador-services" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
    kubectl cluster-info
    kubectl create clusterrolebinding $CLUSTER_NAME-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-crds.yaml
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-rbac.yaml
    EOT
    environment = {
      CLUSTER_NAME =  var.cluster_name
      REGION = var.location
    }
  }
}

variable "cluster_name"{}
variable "location"{}