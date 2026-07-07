.PHONY: up down init-dev plan-dev validate-dev init-prod plan-prod validate-prod

up:
	docker compose up -d

down:
	docker compose down

init-dev:
	cd infra/environments/dev && terraform init

validate-dev:
	cd infra/environments/dev && terraform validate

plan-dev:
	cd infra/environments/dev && terraform plan

init-prod:
	cd infra/environments/prod && terraform init

validate-prod:
	cd infra/environments/prod && terraform validate

plan-prod:
	cd infra/environments/prod && terraform plan
