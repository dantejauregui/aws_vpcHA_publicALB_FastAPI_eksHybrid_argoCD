resource "helm_release" "argocd" {

  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  version = "8.2.7"

  wait    = true
  timeout = 900

  # Ensuring Argo CD controller has the "custom health check" configured in its argocd-cm ConfigMap:
  values = [
    file("${path.module}/values.yaml")
  ]

  set = [

    {
      name  = "server.service.type"
      value = "ClusterIP"
    },

    # TLS termination happens at gateway
    {
      name  = "configs.params.server\\.insecure"
      value = "true"
    }
  ]
}

data "kubernetes_secret_v1" "argocd_admin_secret" {

  metadata {

    name      = "argocd-initial-admin-secret"
    namespace = "argocd"

  }

  depends_on = [
    helm_release.argocd
  ]
}
