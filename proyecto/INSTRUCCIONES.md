# Instrucciones de Ejecución del Proyecto

## Requisitos Previos

1. Asegúrate de tener instalado:
   - Docker Desktop
   - Google Cloud SDK
   - Make (opcional, pero recomendado)

2. Configuración inicial de Google Cloud:
   - Tener una cuenta de Google Cloud Platform
   - Un proyecto creado en GCP
   - APIs necesarias habilitadas (Compute Engine API)

## Pasos de Configuración

### 1. Configuración de Credenciales

1. Autenticarse en Google Cloud:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```

2. Configurar las credenciales (elegir una opción):

   **Opción A - Usando credentials.json:**
   - Crear una cuenta de servicio en GCP
   - Descargar la llave JSON como `credentials.json`
   - Colocarla en la raíz del proyecto
   - Modificar `docker-compose.yml` para usar este archivo:
     ```yaml
     volumes:
       - ./credentials.json:/root/.config/gcloud/application_default_credentials.json
     ```

   **Opción B - Usando gcloud credentials:**
   - Usar las credenciales existentes de gcloud:
     ```bash
     gcloud auth application-default login
     ```
   - Verificar que existe el archivo:
     ```bash
     ls ~/.config/gcloud/application_default_credentials.json
     ```

3. Verificar permisos:
   - La cuenta debe tener permisos de Editor en el proyecto
   - Las siguientes APIs deben estar habilitadas:
     - Compute Engine API
     - Cloud Resource Manager API

### 2. Configuración del Proyecto

1. Editar el archivo `config/infrastructure.yaml`:
   - Actualizar `project_id` con tu ID de proyecto de GCP
   - Ajustar la región y zona según necesites
   - Modificar las configuraciones de red y máquinas virtuales según tus necesidades

### 3. Preparación del Entorno

1. Clonar el repositorio (si aplica):
   ```bash
   git clone <url-del-repositorio>
   cd proyecto
   ```

2. Verificar la estructura de archivos:
   ```
   proyecto/
   ├── config/
   ├── terraform/
   ├── scripts/
   └── ...
   ```

## Ejecución del Proyecto

### Usando Make (Recomendado)

1. Construir la imagen Docker:
   ```bash
   make build
   ```

2. Ejecutar el despliegue:
   ```bash
   make run
   ```

3. Para destruir la infraestructura:
   ```bash
   make destroy
   ```

4. Limpiar recursos Docker:
   ```bash
   make clean
   ```

### Sin Make (Comandos Docker directos)

1. Construir la imagen:
   ```bash
   docker-compose build
   ```

2. Ejecutar el despliegue:
   ```bash
   docker-compose up
   ```

3. Destruir la infraestructura:
   ```bash
   docker-compose run terraform-gcp terraform -chdir=/app/terraform destroy
   ```

## Verificación del Despliegue

1. El script mostrará los outputs con:
   - IPs de las instancias creadas
   - Detalles de la red
   - Estado del despliegue

2. Puedes verificar los recursos en la consola de GCP:
   - Ir a Compute Engine para ver las instancias
   - Revisar VPC Networks para ver la red creada

## Solución de Problemas Comunes

1. Error de credenciales:
   - Verificar que el archivo `credentials.json` está correctamente configurado
   - Asegurar que la cuenta de servicio tiene los permisos necesarios
   - Reautenticarse con `gcloud auth login`

2. Error de APIs:
   - Verificar que las APIs necesarias están habilitadas en GCP
   - Compute Engine API debe estar activa

3. Error de permisos:
   - Asegurar que la cuenta de servicio tiene rol de Editor o roles específicos necesarios
   - Verificar permisos en el proyecto GCP

4. Errores de Docker:
   - Asegurar que Docker Desktop está corriendo
   - Verificar que los volúmenes están correctamente montados
   - Revisar logs con `docker-compose logs`

## Notas Importantes

- Mantén seguras tus credenciales y no las compartas
- Revisa los costos asociados a los recursos antes de desplegarlos
- Usa `make destroy` o el comando equivalente cuando ya no necesites la infraestructura
- Realiza copias de seguridad de tus configuraciones importantes
- Monitorea el uso de recursos en GCP para evitar costos inesperados

## Recursos Adicionales

- [Documentación de Google Cloud](https://cloud.google.com/docs)
- [Documentación de Terraform](https://www.terraform.io/docs)
- [Documentación de Docker](https://docs.docker.com) 