variable "argocd_namespace" {
  description = "The namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "server_service_type" {
  description = "Service type for the ArgoCD server"
  type        = string
  default     = "NodePort"
}
