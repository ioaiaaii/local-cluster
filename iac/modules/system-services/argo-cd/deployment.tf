provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}

## Get depended module status
resource "null_resource" "dependency" {
  triggers = {
    release_statuses = (var.dependency_var)
  }
}

resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_version
  namespace        = var.namespace
  create_namespace = true
  values = [file("${path.module}/values.yaml")]
  wait = true
  timeout = 400
  depends_on = [
    null_resource.dependency
  ]
}
