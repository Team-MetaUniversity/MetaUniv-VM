output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_helm_release_status" {
  value = helm_release.argocd.status
}
