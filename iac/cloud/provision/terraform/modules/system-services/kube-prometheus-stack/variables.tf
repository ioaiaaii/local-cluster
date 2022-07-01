variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}

variable "helm_version" {
  type        = string
  description = "The Helm version."
  default     = "36.2.0"
}

variable "namespace" {
  type        = string
  description = "The nginx ingress namespace (it will be created if needed)."
  default     = "kube-prometheus-stack"
}

variable "dependency_var" {
  type    = string
  description = "Depedens_on best practice, to depend on another module"
}
