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

.PHONY: help
help: # Autogenerates help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m : %s\n", $$1, $$2}'