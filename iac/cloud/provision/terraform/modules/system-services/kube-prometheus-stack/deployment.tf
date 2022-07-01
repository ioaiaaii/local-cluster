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

resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.helm_version
  namespace        = var.namespace
  create_namespace = true
  values = [file("${path.module}/values.yaml")]
  wait = true
  timeout = 800
  depends_on = [
    null_resource.dependency
  ]
}


## Create depedency, and utilize release_status variable in dependend modules
resource "null_resource" "wait_for" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for release health...\n"
      kubectl wait --namespace ${helm_release.kube-prometheus-stack.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=${helm_release.kube-prometheus-stack.timeout}s
    EOF
  }

  depends_on = [helm_release.kube-prometheus-stack]
}
