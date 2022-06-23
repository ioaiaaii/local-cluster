# local-cluster

## Overview

The goal of this project is to provide a simulation of a production cluster in a local workstation. Based on SRE principles, it provides an introduction to the following concepts:

- Declarative Infrastructure
  - IAC
- Service Orchestrator
  - mServices approach
  - Declarative Management
  - Availability and Scalability
- Hermetic Builds/GitOps
  - SSOT
  - Deployment strategies
  - Reusable pipelines
- Observability
  - Monitoring
  - Alerting
  - Reporting and SLIs/SLOs

There are plenty of impressive and quick solutions to spin up a new local cluster and test a workload. In this implementation, I wanted to split the layers within a topology, as close as possible to a production environment, from Infra to Service. Also, it is a project just for fun, experience, and my workstation that I wanted to describe as a code.

## Topology

```yaml
Local workstation >
# Spin up infra
                  Multipass
                  # Init and configure VM
                  # Exec IAC
                            > Ubuntu VM
                            > Terraform
                            # Spin up Kubernetes
                                          > KinD
                                          # GitOps
                                                > Helm
                                                      > Workload
```

## Getting Started

### Tooling

This project requires the following softwares:

- [Multipass](https://multipass.run) - Quick VM Orchestrator
- [VirtualBox](https://www.virtualbox.org) - Reliable virtualization backend for Multipass
- dnsmasq (optional)

### Configuration

#### Local domain resolver

Utilizing dnsmasq, the local system should be configured to resolve FQDNs from the local cluster;s ingresses, by following a really good read [Local Ingress Domains for your Kind Cluster](https://mjpitz.com/blog/2020/10/21/local-ingress-domains-kind/). In this way, you can set any ingress using a specified local domain, and the ingress can be resolved out of the box inside the local workstation.

Note: 
*Configuration following in the next section*

### Tooling and Configuration Steps

Instead of writing a script, which could harm your local workstation packages/versions, some example commands are given for a quick start: [requirements.sh](scripts/requirements.sh)

## Usage

### Create a local Kubernetes Cluster

The following steps will provide a fresh KIND cluster with:

- [NGINX Ingress controller](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)
- [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#kube-prometheus-stack)

```shell
terraform -chdir=iac/clusters init
```

```shell
terraform -chdir=iac/clusters plan
```

```shell
terraform -chdir=iac/clusters apply -auto-approve
```

Get ingresses

```shell
kubectl get ing --all-namespaces
```

```shell
NAMESPACE               NAME                                 CLASS   HOSTS                           ADDRESS     PORTS   AGE
kube-prometheus-stack   kube-prometheus-stack-alertmanager   nginx   alertmanager.cluster.localnet   localhost   80      3h22m
kube-prometheus-stack   kube-prometheus-stack-grafana        nginx   grafana.cluster.localnet        localhost   80      3h22m
kube-prometheus-stack   kube-prometheus-stack-prometheus     nginx   prometheus.cluster.localnet     localhost   80      3h22m
```

## Troubleshooting

### Networking

```shell
nc -v 127.0.0.1 80

ubuntu@primary:~$ echo "test-test" > index.html && while true ; do sudo nc -l 80 < index.html ; done
```

### dnmasq

```shell
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
dscacheutil -flushcache
```

### Multipass

```shell
sudo launchctl unload /Library/LaunchDaemons/com.canonical.multipassd.plist
sudo launchctl load /Library/LaunchDaemons/com.canonical.multipassd.plist
```
