resource "null_resource" "ambassador-services" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
    kubectl cluster-info
    kubectl create clusterrolebinding $CLUSTER_NAME-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-crds.yaml
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-rbac.yaml
    kubectl apply -f ambassador-ingress.yaml
    sleep 120s
    EOT
    environment = {
      CLUSTER_NAME =  var.cluster_name
      REGION = var.location
    }
  }

  triggers = {
    always_run = timestamp()
  }

}

variable "cluster_name"{}
variable "location"{}