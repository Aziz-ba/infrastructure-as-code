.PHONY: fmt validate plan apply destroy configure

fmt:        ## Format all Terraform files
	terraform fmt -recursive

validate:   ## Validate the configuration
	terraform init -backend=false && terraform validate

plan:       ## Show the execution plan
	terraform plan

apply:      ## Provision the infrastructure
	terraform apply

destroy:    ## Tear everything down
	terraform destroy

configure:  ## Generate inventory and run the Ansible playbook
	terraform output -raw ansible_inventory_hint > inventory.ini
	ansible-playbook -i inventory.ini setup.yml
