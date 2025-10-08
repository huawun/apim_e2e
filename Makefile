.PHONY: setup setup-devops deploy-infra deploy-app test clean

setup:
	@echo "Setting up prerequisites..."
	./scripts/setup-prerequisites.sh

setup-devops:
	@echo "Setting up Azure DevOps..."
	./scripts/setup-devops.sh

deploy-infra:
	@echo "Deploying infrastructure..."
	./scripts/deploy-infrastructure.sh

deploy-app:
	@echo "Deploying application..."
	./scripts/deploy-application.sh

test:
	@echo "Testing endpoints..."
	./scripts/test-endpoints.sh

deploy-all: deploy-infra deploy-app

clean:
	@echo "Cleaning up resources..."
	cd terraform && terraform destroy -auto-approve

help:
	@echo "Available commands:"
	@echo "  setup       - Set up Azure prerequisites"
	@echo "  setup-devops - Set up Azure DevOps integration"
	@echo "  deploy-infra - Deploy infrastructure with Terraform"
	@echo "  deploy-app  - Build and deploy application"
	@echo "  deploy-all  - Deploy infrastructure and application"
	@echo "  test        - Test deployed endpoints"
	@echo "  clean       - Destroy all resources"