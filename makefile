SHELL := /bin/bash

.PHONY: deploy-backend apply-environment set-ssm-parameters

deploy-backend:
	cd backend && terraform init && terraform apply

apply-environment:
ifeq ($(env),)
	@echo "env is not set. Please specify the environment directory using the 'env' variable"
	@exit 1
else
	cd environments/$(env) && terraform init && terraform apply
endif

set-ssm-parameters:
	@echo "Setting RDS username and password in AWS SSM Parameter Store..."
	@aws ssm put-parameter \
		--name "/$(env)/rds_username" \
		--value "$(RDS_USERNAME)" \
		--type "SecureString" \
		--description "RDS username" \
		--overwrite \
		--region "$(AWS_REGION)"
	@aws ssm put-parameter \
		--name "/$(env)/rds_password" \
		--value "$(RDS_PASSWORD)" \
		--type "SecureString" \
		--description "RDS password" \
		--overwrite \
		--region "$(AWS_REGION)"
	@echo "RDS username and password set successfully."
