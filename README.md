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

## Usage

### If you living on the edge

```shell
curl https://raw.githubusercontent.com/ioaiaaii/local-cluster/master/scripts/spawn.sh | bash
```

### Step by step

#### Init VM

```shell
multipass set local.driver=virtualbox
multipass launch --cpus 4 --disk 40G --mem 12G --name local-cluster 22.04 --cloud-init clout-init.yaml
multipass mount iac local-cluster:/opt
```

#### Port-forwarding from VM to Host

```shell
sudo VBoxManage showvminfo "local-cluster" | awk '/NIC/ && /Rule/ {print}'
sudo VBoxManage controlvm local-cluster natpf1 "ingress,tcp,,80,,80"
```

#### Spawn K8S in VM

```shell
multipass exec local-cluster -- bash -c "terraform  -chdir=/opt/clusters init"
multipass exec local-cluster -- bash -c "terraform -chdir=/opt/clusters apply -auto-approve"
```

#### Local domain resolver

Utilizing dnsmasq, the local system should be configured to resolve FQDNs from the local cluster;s ingresses, by following a really good read [Local Ingress Domains for your Kind Cluster](https://mjpitz.com/blog/2020/10/21/local-ingress-domains-kind/). In this way, you can set any ingress using a specified local domain, and the ingress can be resolved out of the box inside the local workstation.

```shell
##dnsmaq
## Chose your local domain, or use the following: cluster.localnet
## Be careful not to use TLD that is actually a real TLD.
cat <<EOF | sudo tee -a /usr/local/etc/dnsmasq.conf
address=/cluster.localnet/127.0.0.1
server=8.8.8.8
server=8.8.4.4
EOF

cat <<EOF | sudo tee /etc/resolver/cluster.localnet
domain cluster.localnet
search cluster.localnet
nameserver 127.0.0.1
EOF

sudo brew services start dnsmasq
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
