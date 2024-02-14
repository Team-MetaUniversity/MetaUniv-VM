output "aks_cluster_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_cluster_kube_config" {
  description = "The kube config of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
}
