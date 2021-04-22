resource "null_resource" "gloo-services" {
  provisioner "local-exec" {
    command = <<EOT
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
    kubectl cluster-info
    kubectl create clusterrolebinding $CLUSTER_NAME-admin-binding --clusterrole=cluster-admin --user=$(gcloud info --format="value(config.account)")
    helm init
    helm repo add gloo https://storage.googleapis.com/solo-public-helm
    helm repo update
    kubectl create namespace gloo-system
    helm install gloo gloo/gloo --namespace gloo-system \
      --set gateway.enabled=false,ingress.enabled=true
    kubectl create secret docker-registry gcr-json-key --docker-server=us.gcr.io --docker-username=_json_key --docker-password="$(cat ../../secrets/$SECRET_FILE)" --docker-email=$SERVICE_ACCOUNT
    sleep 240s
    EOT
    environment = {
      CLUSTER_NAME = var.cluster_name
      REGION       = var.location
      SECRET_FILE  = var.secret_file
      SERVICE_ACCOUNT= var.service_account
    }
  }

  triggers = {
    always_run = timestamp()
  }

}

variable "cluster_name" {}
variable "location" {}
variable "secret_file" {}
variable "service_account" {}
