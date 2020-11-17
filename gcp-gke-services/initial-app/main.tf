resource "kubernetes_deployment" "deployment-app" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = var.labels
    }
    template {
      metadata {
        labels = var.labels
      }
      spec {
        container {
          image = var.image
          name  = var.name

          port {
            container_port = var.container_port
          }

          resources {
            limits {
              cpu    = var.cpu_limt     #"0.5"
              memory = var.memory_limit #"512Mi"
            }
            requests {
              cpu    = var.cpu_request    #"250m"
              memory = var.memoru_request #"50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service-app-nodeport" {

  metadata {
    name = var.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.deployment-app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}