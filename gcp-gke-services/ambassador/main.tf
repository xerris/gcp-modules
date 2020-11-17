resource "null_resource" "ambassador-services" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
    kubectl cluster-info
    kubectl create clusterrolebinding $CLUSTER_NAME-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-crds.yaml
    kubectl apply -f https://www.getambassador.io/yaml/ambassador/ambassador-rbac.yaml
    kubectl apply -f ambassador-ingress.yaml
    kubectl create secret docker-registry gcr-json-key --docker-server=us.gcr.io --docker-username=_json_key --docker-password="$(cat secrets/gke-sbx-sa.json)" --docker-email=sa-sizing-poker-sbx-compute@sizing.iam.gserviceaccount.com
    sleep 240s
    EOT
    environment = {
      CLUSTER_NAME = var.cluster_name
      REGION       = var.location
    }
  }

  triggers = {
    always_run = timestamp()
  }

}

variable "cluster_name" {}
variable "location" {}
