
resource "helm_release" "pgadmin4" {
  name       = "pgadmin4"
  repository = "https://helm.runix.net"
  chart      = "pgadmin4"

  # Optional but recommended
  namespace        = "default"
  create_namespace = true

  set {
    name  = "env.email"
    value = "admin@example.com"
  }

  set {
    name  = "env.password"
    value = "q1w2e3r4100@"
  }
}
