IAC_LOCAL_PATH = "iac/local/provision/"

start-local-cluster: ## Start local cluster
	@echo "Creatinig local cluster, this will take a while."
	@echo "+++"
	@echo ""
	cd ${IAC_LOCAL_PATH} && vagrant up --provision

status-local-cluster: ## Get the status of local cluster
	cd ${IAC_LOCAL_PATH} && vagrant status

suspend-local-cluster: ## Suspend status of local cluster
	cd ${IAC_LOCAL_PATH} && vagrant suspend

reload-local-cluster: ## Reload/Upgrade local cluster
	cd ${IAC_LOCAL_PATH} && vagrant reload --provision

destroy-local-cluster: ## Destroy local cluster
	cd ${IAC_LOCAL_PATH} && vagrant destroy

restart-local-cluster: ## Restart local cluster
	cd ${IAC_LOCAL_PATH} && vagrant reload

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