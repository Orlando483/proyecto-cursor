# Imagen base
FROM python:3.9-slim

# Argumentos de construcción
ARG TERRAFORM_VERSION=1.5.7
ARG GCLOUD_VERSION=446.0.0

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Google Cloud SDK
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && tar -xf google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && ./google-cloud-sdk/install.sh --quiet \
    && rm google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz

# Instalar Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY requirements.txt .
COPY config/ ./config/
COPY terraform/ ./terraform/
COPY scripts/ ./scripts/

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Variable de entorno para el PATH de Google Cloud SDK
ENV PATH $PATH:/google-cloud-sdk/bin

# Script de entrada
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"] 