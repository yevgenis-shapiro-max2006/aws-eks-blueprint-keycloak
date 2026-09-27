
resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

resource "helm_release" "keycloak" {
  name       = "keycloak"
  namespace  = kubernetes_namespace_v1.keycloak.metadata[0].name
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "keycloak"

  # Optional: pin the chart version after checking available versions
  # version = "..."

  timeout         = 1200
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      auth = {
        adminUser     = "admin"
        adminPassword = var.keycloak_admin_password
      }

      image = {
        repository = "bitnamilegacy/keycloak"
        tag        = "26.3.3-debian-12-r0"
      }

      postgresql = {
        enabled = false
      }

      externalDatabase = {
        host     = var.keycloak_db_host
        port     = 5432
        user     = var.keycloak_db_user
        database = var.keycloak_db_name
        password = var.keycloak_db_password
      }

      proxyHeaders = "xforwarded"

      hostname = "auth.appflex.io"
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.keycloak
  ]
}
