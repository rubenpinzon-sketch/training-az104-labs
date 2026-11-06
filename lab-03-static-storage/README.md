# Lab 03 — Sitio Web Estático en Azure Storage Account

## Descripción

Configura un **Azure Storage Account** con la función de **Static Website** habilitada
y despliega una página web de demostración (`index.html`) accesible públicamente via HTTPS.

## Servicio Azure

**Azure Blob Storage** — Static Website hosting

## Prerrequisitos

- Azure CLI autenticado: `az login`
- Suscripción Azure con permisos de Contributor

## Instrucciones

### 1. Crear el Storage Account

```bash
# Variables — ajusta según tu entorno
RESOURCE_GROUP="rg-static-lab03"
STORAGE_ACCOUNT="stlab03$(date +%s | tail -c 6)"  # nombre único
LOCATION="eastus"

# Crear Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Crear Storage Account (SKU Standard_LRS)
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2
```

### 2. Habilitar Static Website

```bash
az storage blob service-properties update \
  --account-name $STORAGE_ACCOUNT \
  --static-website \
  --index-document index.html \
  --404-document index.html
```

### 3. Subir el archivo index.html

```bash
az storage blob upload \
  --account-name $STORAGE_ACCOUNT \
  --container-name '$web' \
  --name index.html \
  --file index.html \
  --content-type "text/html"
```

### 4. Obtener la URL pública

```bash
az storage account show \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query "primaryEndpoints.web" \
  --output tsv
```

Abre la URL en tu navegador para verificar el despliegue.

## 🗑️ Limpieza (obligatorio)

```bash
az group delete --name $RESOURCE_GROUP --yes --no-wait
```

## ⚠️ Notas

- El contenedor `$web` se crea automáticamente al habilitar Static Website.
- La URL es pública y no requiere autenticación.
- El Storage Account genera costos mínimos pero recuerda eliminarlo al finalizar.
