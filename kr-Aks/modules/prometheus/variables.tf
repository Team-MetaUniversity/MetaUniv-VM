variable "prometheus_namespace" {
  description = "The namespace for Prometheus"
  type        = string
  default     = "prometheus"
}

variable "service_type" {
  description = "Service type for the Prometheus server"
  type        = string
  default     = "NodePort"
}
