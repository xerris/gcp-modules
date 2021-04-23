terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "0.1.3"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.9.1"
    }
  }
}


data "flux_install" "main" {
  target_path    = var.target_path
  network_policy = false
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "apply" {
  content = data.flux_install.main.content
}
output "kubectl_apply" {
  value = { content = data.kubectl_file_documents.apply
  }

}

# Apply manifests on the cluster
resource "kubectl_manifest" "apply" {
  count     = 20
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = element(data.kubectl_file_documents.apply.documents, count.index)
}

####################################################
####################################################
####################################################

data "flux_sync" "main" {
  target_path = var.target_path
  url         = "https://github.com/${var.github_owner}/${var.repository_name}"
  branch      = var.branch
}

# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

# Apply manifests on the cluster
resource "kubectl_manifest" "sync" {
  count = 20
  depends_on = [kubectl_manifest.apply, kubernetes_namespace.flux_system]
  yaml_body = element(data.kubectl_file_documents.sync.documents, count.index)
}

output "kubectl_sync" {
  value = { content = data.kubectl_file_documents.sync
  }

}
# Generate a Kubernetes secret with the Git credentials
resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.apply]
  metadata {
    name      = "flux-system" #data.flux_sync.main.name
    namespace = kubernetes_namespace.flux_system.metadata[0].name
  }

  data = {
    username = "sizingpoker-bot"
    password = var.flux_token
  }
}