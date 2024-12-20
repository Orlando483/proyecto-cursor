#!/bin/bash
set -e

# Función para verificar credenciales
check_credentials() {
    if [ ! -f "/root/.config/gcloud/application_default_credentials.json" ]; then
        echo "Error: No se encontraron credenciales de GCP."
        echo "Asegúrate de:"
        echo "1. Montar el archivo credentials.json, o"
        echo "2. Montar las credenciales de gcloud"
        return 1
    fi

    if [ ! -r "/root/.config/gcloud/application_default_credentials.json" ]; then
        echo "Error: No hay permisos de lectura en el archivo de credenciales"
        return 1
    fi
    return 0
}

# Función para verificar configuración
check_config() {
    if [ ! -f "/app/config/infrastructure.yaml" ]; then
        echo "Error: No se encuentra el archivo de configuración"
        return 1
    fi
    return 0
}

# Verificaciones iniciales
echo "Verificando configuración..."
check_config || exit 1

echo "Verificando credenciales..."
check_credentials || exit 1

echo "Iniciando despliegue..."
python scripts/deploy.py 