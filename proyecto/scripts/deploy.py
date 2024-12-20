import yaml
import subprocess
from pathlib import Path
import json
import sys
import os
import logging

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def check_gcloud_installation():
    """Verifica la instalación de gcloud y las credenciales"""
    try:
        subprocess.run(['gcloud', '--version'], 
                      capture_output=True, 
                      check=True)
        
        creds_path = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
        if not creds_path:
            logging.error("Variable GOOGLE_APPLICATION_CREDENTIALS no está configurada")
            return False
            
        if not os.path.exists(creds_path):
            logging.error(f"No se encontró el archivo de credenciales en {creds_path}")
            return False
            
        if not os.access(creds_path, os.R_OK):
            logging.error(f"No hay permisos de lectura para {creds_path}")
            return False
            
        return True
    except Exception as e:
        logging.error(f"Error al verificar la instalación de gcloud: {e}")
        return False

def validate_yaml_config(config):
    """Valida la estructura del archivo YAML"""
    required_fields = ['infrastructure', 'project_id', 'region', 'zone']
    for field in required_fields:
        if field not in config.get('infrastructure', {}):
            logging.error(f"Campo requerido '{field}' no encontrado en la configuración")
            return False
    return True

def read_config():
    """Lee y valida el archivo de configuración"""
    try:
        with open('config/infrastructure.yaml', 'r') as file:
            config = yaml.safe_load(file)
            if not validate_yaml_config(config):
                sys.exit(1)
            return config
    except FileNotFoundError:
        logging.error("No se encuentra el archivo config/infrastructure.yaml")
        sys.exit(1)
    except yaml.YAMLError as e:
        logging.error(f"Error al leer el archivo YAML: {e}")
        sys.exit(1)

def run_terraform_commands():
    """Ejecuta los comandos de Terraform"""
    terraform_dir = Path('terraform')
    
    try:
        logging.info("Inicializando Terraform...")
        subprocess.run(['terraform', 'init'], 
                      cwd=terraform_dir, 
                      check=True)

        logging.info("Creando plan de Terraform...")
        subprocess.run(['terraform', 'plan'], 
                      cwd=terraform_dir, 
                      check=True)

        response = input("\n¿Deseas aplicar estos cambios? (y/n): ")
        if response.lower() != 'y':
            logging.info("Operación cancelada por el usuario")
            return False

        logging.info("Aplicando cambios...")
        subprocess.run(['terraform', 'apply', '-auto-approve'],
                      cwd=terraform_dir,
                      check=True)
        
        logging.info("Mostrando outputs...")
        subprocess.run(['terraform', 'output'], 
                      cwd=terraform_dir,
                      check=True)
        return True
            
    except subprocess.CalledProcessError as e:
        logging.error(f"Error en comando de Terraform: {e}")
        return False
    except Exception as e:
        logging.error(f"Error inesperado: {e}")
        return False

def main():
    logging.info("Iniciando despliegue de infraestructura...")
    
    if not check_gcloud_installation():
        sys.exit(1)

    config = read_config()
    logging.info("Configuración leída correctamente")

    if not run_terraform_commands():
        sys.exit(1)

    logging.info("Despliegue completado exitosamente")

if __name__ == '__main__':
    main() 