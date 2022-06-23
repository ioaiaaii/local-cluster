module "kind_cluster" {
  source = "../modules/kind/"
  cluster_name          = "local-cluster"
}

module "nginx-ingress" {
  source = "../modules/system-services/ingress-nginx/"
  kind_cluster_config_path = module.kind_cluster.kubeconfig_path
}

#module "kube-prometheus-stack" {
#  source = "../modules/system-services/kube-prometheus-stack"
#  kind_cluster_config_path = module.kind_cluster.kubeconfig_path
#  dependency_var = module.nginx-ingress.release_status
#}

# module "argo-cd" {
#   source = "../modules/system-services/argo-cd"
#   kind_cluster_config_path = module.kind_cluster.kubeconfig_path
#   dependency_var = module.kube-prometheus-stack.release_status
# }
