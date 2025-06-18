.PHONY: setup init plan apply destroy clean outputs help s3

# Variables
TF_OUTPUT_FILE := terraform-outputs.json
CODEBUILD_PROJ_NAME := $(shell grep codebuild_proj_name terraform.tfvars | cut -d '"' -f2)

help:
	@echo "Available commands:"
	@echo "  make setup				 - Setup empty project files."
	@echo "  make init               - Initialize Terraform"
	@echo "  make plan               - Run Terraform plan"
	@echo "  make apply              - Run Terraform apply and save outputs to JSON"
	@echo "  make outputs            - Save current Terraform outputs to JSON"
	@echo "  make s3 #yourbucketname - Update providers.tf and terraformvars.tf with your S3 bucket name."

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

s3:
	@bucket=$(word 2,$(MAKECMDGOALS)); \
	echo "Bucket name is: $$bucket"; \
	sed -i 's~bucket = ".*"~bucket = "'"$$bucket"'"~g' providers.tf; \
	sed -i 's~bucket_name = ".*"~bucket_name = "'"$$bucket"'"~g' terraform.tfvars

scan_image:
	@set -x; \
	echo "Extracted project name: '$(CODEBUILD_PROJ_NAME)'"; \
	aws codebuild start-build --project-name "$(CODEBUILD_PROJ_NAME)"

outputs:
	terraform output -json > $(TF_OUTPUT_FILE)
	@echo "Outputs saved to $(TF_OUTPUT_FILE)"

destroy:
	terraform destroy

clean:
	rm -f $(TF_OUTPUT_FILE)

# Prevent make from trying to build the bucket name as a target
%:
	@: