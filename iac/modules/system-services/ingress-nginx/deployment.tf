provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_helm_version
  namespace        = var.ingress_nginx_namespace
  create_namespace = true
  values = [file("${path.module}/values.yaml")]
  wait = true
  timeout = 300
  
}

## Create depedency, and utilize release_status variable in dependend modules
resource "null_resource" "wait_for" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for release health...\n"
      kubectl wait --namespace ${helm_release.ingress_nginx.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=${helm_release.ingress_nginx.timeout}s
    EOF
  }

  depends_on = [helm_release.ingress_nginx]
}
