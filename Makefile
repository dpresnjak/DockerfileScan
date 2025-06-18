.PHONY: setup init plan apply destroy clean outputs help

# Variables
TF_OUTPUT_FILE := terraform-outputs.json

help:
	@echo "Available commands:"
	@echo "  make setup				 - Setup empty project files."
	@echo "  make init               - Initialize Terraform"
	@echo "  make plan               - Run Terraform plan"
	@echo "  make apply              - Run Terraform apply and save outputs to JSON"
	@echo "  make outputs            - Save current Terraform outputs to JSON"

setup:
	mkdir modules environments
	mkdir environments/prod environments/dev
	touch environments/prod/prod.tfvars environments/dev/dev.tfvars
	touch main.tf outputs.tf providers.tf variables.tf terraform.tfvars

init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply -auto-approve

outputs:
	terraform output -json > $(TF_OUTPUT_FILE)
	@echo "Outputs saved to $(TF_OUTPUT_FILE)"

destroy:
	terraform destroy

clean:
	rm -f $(TF_OUTPUT_FILE)