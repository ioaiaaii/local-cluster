resource "kind_cluster" "this" {
  name            = var.cluster_name
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      image      = "${var.kind_image}:v${var.kubernetes_version}"
      kubeadm_config_patches = var.kubeadm_config_patches.master
      extra_port_mappings {
        container_port = 80
        host_port      = 80
        listen_address = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        listen_address = "0.0.0.0"
      }
    }

    node {
      role = "worker"
      image      = "${var.kind_image}:v${var.kubernetes_version}"
      kubeadm_config_patches = var.kubeadm_config_patches.infra
    }

    node {
      role = "worker"
      image      = "${var.kind_image}:v${var.kubernetes_version}"
      kubeadm_config_patches = var.kubeadm_config_patches.app
    }
  }
}
