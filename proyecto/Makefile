.PHONY: build run destroy clean validate plan logs

# Variables
DOCKER_COMPOSE = docker-compose
TERRAFORM_SERVICE = terraform-gcp

build:
	$(DOCKER_COMPOSE) build

run:
	$(DOCKER_COMPOSE) up

validate:
	$(DOCKER_COMPOSE) run $(TERRAFORM_SERVICE) terraform -chdir=/app/terraform validate

plan:
	$(DOCKER_COMPOSE) run $(TERRAFORM_SERVICE) terraform -chdir=/app/terraform plan

apply:
	$(DOCKER_COMPOSE) run $(TERRAFORM_SERVICE) terraform -chdir=/app/terraform apply

destroy:
	$(DOCKER_COMPOSE) run $(TERRAFORM_SERVICE) terraform -chdir=/app/terraform destroy

logs:
	$(DOCKER_COMPOSE) logs -f

clean:
	$(DOCKER_COMPOSE) down
	docker system prune -f

help:
	@echo "Comandos disponibles:"
	@echo "  build     - Construir la imagen Docker"
	@echo "  run       - Ejecutar el despliegue"
	@echo "  validate  - Validar la configuración de Terraform"
	@echo "  plan      - Ver el plan de Terraform"
	@echo "  apply     - Aplicar cambios de Terraform"
	@echo "  destroy   - Destruir la infraestructura"
	@echo "  logs      - Ver logs en tiempo real"
	@echo "  clean     - Limpiar recursos Docker"