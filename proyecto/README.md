# Proyecto de Despliegue de Infraestructura en GCP

Este proyecto permite desplegar infraestructura en Google Cloud Platform utilizando Terraform y Python, basándose en configuraciones YAML. El proyecto está dockerizado para facilitar su ejecución y mantener la consistencia del entorno.

## Requisitos Previos

- Docker Desktop para Windows
- Google Cloud SDK
- Make (opcional, para usar comandos simplificados)

## Estructura del Proyecto

proyecto/
├── config/
│   └── infrastructure.yaml    # Configuración de infraestructura
├── terraform/
│   ├── main.tf               # Definición principal de recursos
│   ├── variables.tf          # Variables de Terraform
│   └── outputs.tf            # Outputs de Terraform
├── scripts/
│   └── deploy.py             # Script principal de despliegue
├── Dockerfile                # Definición de la imagen Docker
├── docker-compose.yml        # Configuración de Docker Compose
├── docker-entrypoint.sh      # Script de entrada Docker
├── Makefile                  # Comandos make
├── INSTRUCCIONES.md          # Guía detallada de uso
├── requirements.txt          # Dependencias Python
└── .gitignore               # Configuración de git

## Uso

1. Configura tu infraestructura en `config/infrastructure.yaml`
2. Ejecuta el script de despliegue:   ```bash
   python scripts/deploy.py   ```

## Recursos Desplegados

- VPC Network
- Subnet
- Compute Engine Instance

## Notas Importantes

- Asegúrate de tener las APIs necesarias habilitadas en tu proyecto de GCP
- Revisa los costos asociados a los recursos antes de desplegarlos
- Usa `terraform destroy` para eliminar la infraestructura cuando ya no la necesites

## Comandos Principales 

## Funcionalidades

### 1. Gestión de Configuración
- Lectura de configuración desde archivo YAML
- Validación de parámetros de configuración
- Personalización flexible de recursos mediante archivo de configuración

### 2. Automatización de Despliegue
- Generación automática de archivos Terraform desde YAML
- Ejecución secuencial de comandos Terraform
- Validación previa al despliegue
- Confirmación interactiva antes de aplicar cambios

### 3. Recursos de Red
- Creación de VPC personalizada
- Configuración de subredes
- Reglas de firewall automáticas:
  - HTTP (80)
  - HTTPS (443)
  - SSH (22)

### 4. Compute Engine
- Despliegue de instancias virtuales
- Configuración automática mediante startup scripts
- Instalación automática de Nginx
- Asignación de IP pública
- Etiquetado automático para reglas de firewall

### 5. Gestión de Estado
- Seguimiento del estado de la infraestructura
- Capacidad de actualización incremental
- Opción de backend remoto para estado (GCS)
- Prevención de conflictos mediante state locking

### 6. Seguridad
- Manejo seguro de credenciales
- Reglas de firewall restrictivas
- Separación de configuración y código
- Exclusión de archivos sensibles del control de versiones

### 7. Monitoreo y Outputs
- Visualización de IPs y nombres de recursos
- Estado de despliegue en tiempo real
- Logs de operaciones
- Información detallada de recursos creados

### 8. Gestión de Errores
- Validación de credenciales GCP
- Verificación de APIs habilitadas
- Manejo de errores en tiempo de ejecución
- Rollback automático en caso de fallos

### 9. Personalización
- Configuración flexible de tipos de máquina
- Selección de imágenes de sistema operativo
- Personalización de rangos IP
- Configuración de tags y metadatos

### 10. Ciclo de Vida
- Inicialización de infraestructura
- Actualización de recursos
- Destrucción controlada de recursos
- Gestión de dependencias entre recursos

## Flujo de Trabajo Detallado

1. **Preparación**
   - Validación de credenciales
   - Lectura de configuración
   - Verificación de requisitos

2. **Generación**
   - Procesamiento de YAML
   - Generación de archivos Terraform
   - Validación de configuración

3. **Despliegue**
   - Inicialización de Terraform
   - Planificación de cambios
   - Confirmación de usuario
   - Aplicación de cambios

4. **Verificación**
   - Validación de recursos creados
   - Muestra de outputs
   - Verificación de conectividad

5. **Mantenimiento**
   - Actualización de recursos
   - Monitoreo de estado
   - Gestión de cambios
   - Limpieza de recursos

## Comandos Principales 