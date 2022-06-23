variable "cluster_name" {
  type        = string
  description = "The Kubernetes Cluster name"
}

variable "kind_image" {
  description = "Kind image version for kubernetes cluster"
  type        = string
  default     = "kindest/node"
}

variable "kubernetes_version" {
  description = "Specific kubernetes version to create cluster, Must specific in SemVer version. (Check all supported version -> https://hub.docker.com/r/kindest/node/tags)"
  type        = string
  default     = "1.23.4"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "The location where this cluster's kubeconfig will be saved to."
  default     = "~/.kube/config"
}

variable "kubeadm_config_patches" {
  description = "Patches to apply on each node group"
  default = {
    master : [
    <<-EOT
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
              node-labels: "ingress-ready=true"

    EOT
    ]

    infra : [
    <<-EOT
      kind: JoinConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "role=infra"
          
    EOT
    ]

    app : [
    <<-EOT
      kind: JoinConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "role=app"
    EOT
    ]
  }
}