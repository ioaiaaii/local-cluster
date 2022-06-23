
#!/bin/bash

multipass set local.driver=virtualbox
multipass launch --cpus 4 --disk 40G --mem 12G --name local-cluster 22.04 --cloud-init clout-init.yaml

sudo VBoxManage showvminfo "local-cluster" | awk '/NIC/ && /Rule/ {print}'
sudo VBoxManage controlvm local-cluster natpf1 "ingress,tcp,,80,,80"

multipass mount ../iac local-cluster:/opt
multipass exec local-cluster -- bash -c "terraform  -chdir=/opt/clusters init"
multipass exec local-cluster -- bash -c "terraform -chdir=/opt/clusters apply -auto-approve"
