
resource "kubernetes_ingress_v1" "keycloak" {
  metadata {
    name      = "ingress-route-keycloak"
    namespace = "keycloak"
    annotations = {
      "konghq.com/strip-path" = "true"
      # Optional:
      # "konghq.com/protocols"                 = "https"
      # "konghq.com/https-redirect-status-code" = "301"
      # "cert-manager.io/cluster-issuer"      = "letsencrypt-prod"
    }
  }

  spec {
    ingress_class_name = "kong"

    tls {
      hosts       = ["auth.crypterio.co"]
      secret_name = "keycloak-tls"
    }

    rule {
      host = "auth.crypterio.co"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "keycloak"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

