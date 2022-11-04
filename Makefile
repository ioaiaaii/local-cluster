IAC_LOCAL_PATH = "iac/local/provision/"


ARGS ?=""

start-local-cluster: ## Start local cluster. If you want to parse Ansible args, call it with ARG var. e.g. make start-local-cluster ARGS='--skip-tags="gitOps"'
	@echo "Creatinig local cluster, this will take a while."
	@echo "+++"
	@echo "${ARGS}"
	cd ${IAC_LOCAL_PATH} && ANSIBLE_ARGS="${ARGS}" vagrant up --provision

run-local-cluster: ## Run Ansible configuration runs/updates. Call it with ARG var, to parse Ansible args.(Similar with start-local-cluster).e.g. make run-local-cluster ARGS='--skip-tags=gitOps --tags=master'
	@echo "Executing local cluster, with ARGS:"
	@echo "${ARGS}"
	cd ${IAC_LOCAL_PATH} && ANSIBLE_ARGS="${ARGS}" vagrant up --provision

status-local-cluster: ## Get the status of local cluster
	cd ${IAC_LOCAL_PATH} && vagrant status

suspend-local-cluster: ## Suspend status of local cluster
	cd ${IAC_LOCAL_PATH} && vagrant suspend

reload-local-cluster: ## Upgrade the VMs configuration or just restart cluster.
	cd ${IAC_LOCAL_PATH} && vagrant reload

destroy-local-cluster: ## Destroy local cluster
	cd ${IAC_LOCAL_PATH} && vagrant destroy

local-kubeconf:
	@kubectl config unset users.local-user || true && \
	kubectl config unset clusters.local-cluster || true && \
	kubectl config unset contexts.local-user@local-cluster|| true && \
	cp $$HOME/.kube/config $$HOME/.kube/config.backup.$$(date +%Y-%m-%d.%H:%M:%S) && \
	KUBECONFIG=$$HOME/.kube/config:/tmp/local-user-kubeconfig kubectl config view --merge --flatten > $$HOME/.kube/merged_kubeconfig && \
	mv $$HOME/.kube/merged_kubeconfig $$HOME/.kube/config && echo "Kubeconfig updated..." && \
	kubectl config use-context local-user@local-cluster

.PHONY: help
help: # Autogenerates help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m : %s\n", $$1, $$2}'