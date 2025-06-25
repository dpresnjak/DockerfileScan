.PHONY: setup init plan apply destroy clean outputs help s3

# Variables
TF_OUTPUT_FILE := terraform-outputs.json
CODEBUILD_PROJ_NAME := $(shell grep codebuild_proj_name terraform.tfvars | cut -d '"' -f2)
BUILD_ID=$(shell aws codebuild list-builds-for-project --project-name $(CODEBUILD_PROJ_NAME) --sort-order DESCENDING --max-items 1 --output json --query ids[0])
LOG_STREAM_NAME=$(shell aws codebuild batch-get-builds --ids $(BUILD_ID) --output json --query builds[0].logs.streamName)

help:
	@echo "Available commands:"
	@echo "	make setup					- Setup empty Terraform project files."
	@echo "	make init					- Initialize Terraform"
	@echo "	make plan					- Run Terraform plan"
	@echo "	make apply					- Run Terraform apply (-auto-approve) and save outputs to JSON"
	@echo "	make outputs					- Save current Terraform outputs to JSON"
	@echi " make destroy					- Run Terraform destroy (Without -auto-approve)."
	@echo "	make s3 yourbucketname				- Update providers.tf and terraformvars.tf with your S3 bucket name."
	@echo "	make scan_image					- Start the deployed CodeBuild project."
	@echo "	make tail_logs					- Start tailing and following the full log group across streams; easier to read."
	@echo "	make get_logs					- Get CloudWatch logs from the latest CodeBuild project run."

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
	@echo "Extracted project name: '$(CODEBUILD_PROJ_NAME)'"; \
	aws codebuild start-build --project-name "$(CODEBUILD_PROJ_NAME)"

get_logs:
	echo "Build ID: $(BUILD_ID)"
	echo "Log stream name: $(LOG_STREAM_NAME)"
	aws logs get-log-events --log-group-name /aws/codebuild/$(CODEBUILD_PROJ_NAME) --log-stream-name $(LOG_STREAM_NAME) --start-from-head --output text

tail_logs:
	aws logs tail /aws/codebuild/$(CODEBUILD_PROJ_NAME) --follow

outputs:
	terraform output -json > $(TF_OUTPUT_FILE)
	@echo "Outputs saved to $(TF_OUTPUT_FILE)"

destroy:
	terraform destroy

# Prevent make from trying to build the bucket name as a target
%:
	@: