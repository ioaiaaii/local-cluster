output "cluster_name" {
  description = "The name of cluster, Can be for kube context."
  value       = kind_cluster.this.name
}

output "kubeconfig_path" {
  description = "Path to kubeconfig file for this kind cluster that auto generated."
  value       = kind_cluster.this.kubeconfig_path
}

output "kubeconfig" {
  description = "Plaintext for kubeconfig generated for this kind cluster."
  value       = kind_cluster.this.kubeconfig
}

output "client_certificate" {
  description = "Client certificate content."
  value       = kind_cluster.this.client_certificate
}

output "client_key" {
  description = "Client key content."
  value       = kind_cluster.this.client_key
}

output "cluster_ca_certificate" {
  description = "CA Certificate content."
  value       = kind_cluster.this.cluster_ca_certificate
}

output "endpoint" {
  description = "Cluster endpoint."
  value       = kind_cluster.this.endpoint
}