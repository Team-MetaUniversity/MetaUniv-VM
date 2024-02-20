variable "grafana_namespace" {
  description = "The namespace for Grafana"
  type        = string
  default     = "grafana"
}

variable "service_type" {
  description = "Service type for the Grafana service"
  type        = string
  default     = "NodePort"
}
