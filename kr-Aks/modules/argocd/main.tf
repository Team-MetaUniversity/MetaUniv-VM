resource "kubernetes_namespace" "argocd" {
  provider = kubernetes
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  provider    = helm
  name        = "argocd"
  repository  = "https://argoproj.github.io/argo-helm"
  chart       = "argo-cd"
  namespace   = kubernetes_namespace.argocd.metadata[0].name
  depends_on  = [kubernetes_namespace.argocd]

  set {
    name  = "server.service.type"
    value = var.server_service_type
  }
}
