
locals {
  keycloak_namespace = "keycloak"

  keycloak = {
    admin_user     = "admin"
    admin_password = "admin"

    db_user     = "keycloak"
    db_password = "keycloak"
    db_name     = "keycloak"

    hostname = "auth.crypterio.co"
  }
}

resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = local.keycloak_namespace
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = kubernetes_namespace_v1.keycloak.metadata[0].name

  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"

  timeout         = 1200
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      auth = {
        adminUser     = local.keycloak.admin_user
        adminPassword = local.keycloak.admin_password
      }

      image = {
        repository = "bitnamilegacy/keycloak"
        tag        = "26.3.3-debian-12-r0"
      }

      production  = true
      httpEnabled = true

      proxyHeaders = "xforwarded"

      extraEnvVars = [
        {
          name  = "KC_HOSTNAME"
          value = "https://auth.crypterio.co"
        }
      ]

      ingress = {
        enabled = false
      }

      postgresql = {
        enabled = true

        auth = {
          username      = local.keycloak.db_user
          password      = local.keycloak.db_password
          database      = local.keycloak.db_name
          postgresPassword = local.keycloak.db_password
        }

        primary = {
          persistence = {
            enabled      = true
            storageClass = "gp3"
            size         = "10Gi"
          }
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.keycloak
  ]
}
