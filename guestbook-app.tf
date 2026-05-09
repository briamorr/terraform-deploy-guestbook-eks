resource "kubernetes_deployment_v1" "redis-follower" {
  metadata {
    name = "redis-follower"
    labels = {
      app  = "redis"
      role = "follower"
      tier = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "redis"
        role = "follower"
        tier = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app  = "redis"
          role = "follower"
          tier = "backend"
        }
      }
      spec {
        container {
          name  = "follower"
          image = "us-docker.pkg.dev/google-samples/containers/gke/gb-redis-follower:v2"

          resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "redis-leader" {
  metadata {
    name = "redis-leader"
    labels = {
      app  = "redis"
      role = "leader"
      tier = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "redis"
        role = "leader"
        tier = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app  = "redis"
          role = "leader"
          tier = "backend"
        }
      }
      spec {
        container {
          name  = "leader"
          image = "registry.k8s.io/redis@sha256:cb111d1bd870a6a471385a4a69ad17469d326e9dd91e0e455350cacf36e1b3ee"

          resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "redis-follower" {
  metadata {
    name = "redis-follower"
    labels = {
      app  = "redis"
      role = "follower"
      tier = "backend"
    }
  }
  spec {
    port {
      port = 6379
    }
    selector = {
      app  = "redis"
      role = "follower"
      tier = "backend"
    }
  }
}
resource "kubernetes_service_v1" "redis-leader" {
  metadata {
    name = "redis-leader"
    labels = {
      app  = "redis"
      role = "leader"
      tier = "backend"
    }
  }
  spec {
    port {
      port = 6379
    }
    selector = {
      app  = "redis"
      role = "leader"
      tier = "backend"
    }
  }
}

resource "kubernetes_deployment_v1" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app  = "guestbook"
      tier = "frontend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app  = "guestbook"
        tier = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app  = "guestbook"
          tier = "frontend"
        }
      }
      spec {
        container {
          name  = "php-redis"
          image = "us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5"

          env {
            name  = "GET_HOSTS_FROM"
            value = "dns"
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app  = "guestbook"
      tier = "frontend"
    }
  }
  spec {
    port {
      port = 80
    }
    selector = {
      app  = "guestbook"
      tier = "frontend"
    }
    type = "LoadBalancer"
  }
}
output "guestbook_load_balancer_host" {
  value = kubernetes_service_v1.frontend.status[0].load_balancer[0].ingress[0].hostname
}
