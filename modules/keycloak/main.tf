
locals {
  keycloak_namespace = "keycloak"

  keycloak = {
    admin_user     = "admin"
    admin_password = "admin"

    db_host     = "dev.c3433333fb2.eu-west-2.rds.amazonaws.com"
    db_port     = 5432
    db_user     = "keycloak"
    db_name     = "keycloak"
    db_password = "keycloak"

    hostname = "auth.appflex.io"
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

      postgresql = {
        enabled = false
      }

      externalDatabase = {
        host     = local.keycloak.db_host
        port     = local.keycloak.db_port
        user     = local.keycloak.db_user
        database = local.keycloak.db_name
        password = local.keycloak.db_password
      }

      proxyHeaders = "xforwarded"

      hostname = local.keycloak.hostname
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.keycloak
  ]
}
