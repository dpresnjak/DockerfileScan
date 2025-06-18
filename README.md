# DockerfileScan - WIP

## Overview

**DockerfileScan** is an infrastructure-as-code project designed to automate the building, scanning, and analysis of Docker images, focusing on identifying vulnerabilities and misconfigurations in Dockerfiles and container images. The project leverages tools like [Trivy](https://github.com/aquasecurity/trivy) for vulnerability scanning and integrates with AWS services via Terraform for scalable, repeatable deployments.

AWS Services created and used:
- S3
- CodeBuild
- Elastic Code Repository (ECR)

---

## Features

- Automated Docker image build and scan workflows.
- Vulnerability scanning of Docker images using Trivy.
- Infrastructure provisioning using Terraform for AWS resources.
- Modular and extensible design for easy customization.
- Support for exporting scan reports and artifacts.

---

## Repository Structure

- `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`  
  Terraform configuration files to provision required cloud infrastructure and resources.

- `Dockerfile`  
  Sample Dockerfile(s) used for building images to be scanned.

- `Makefile`  
  Automation scripts for common tasks like building images, running scans, and deploying infrastructure.

- `modules/`  
  Terraform modules to organize and reuse infrastructure code.

- `build_source/`  
  Build context and source files for Docker image creation.

---

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) installed
- AWS CLI configured with appropriate permissions

### Usage

1. Login to AWS using *aws sso* or by copy-pasting access tokens to the CLI.
2. Update *providers.tf* file with your bucket name for setting up S3 backend for storing the Terraform state file.
3. Run *terraform init* to initialize the Terraform modules and setup providers.
4. Copy your *Dockerfile* to the build_source *directory*.
5. Update *terraform.tfvars* for the S3 bucket name where the Dockerfile and buildspec will be stored, and other variables if needed.
6. Run *make plan* to view resources that will be deployed.
7. Run *make apply* to deploy all resources.
8. Run *make scan_image* to run the CodeBuild project that was created.