resource "null_resource" "ambassador-service" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl create clusterrolebinding $CLUSTER_NAME-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-crds.yaml
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-rbac.yaml
    EOT
    environment = {
      CLUSTER_NAME =  var.cluster_name
    }
  }
}

variable "cluster_name"{}