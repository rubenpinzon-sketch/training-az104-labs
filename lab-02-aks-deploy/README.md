# Lab 02 — Despliegue de AKS con nginx (externo e interno)

## Descripción

Despliega un cluster **Azure Kubernetes Service (AKS)** con un **Azure Container Registry (ACR)**,
construye una imagen nginx personalizada, y despliega dos servicios:
uno expuesto públicamente (Load Balancer externo) y otro interno.

## Servicios Azure

- **Azure Kubernetes Service (AKS)** — cluster con 1 nodo `Standard_D2s_v3`
- **Azure Container Registry (ACR)** — SKU Basic, nombre generado automáticamente

## Recursos que se crean

| Recurso | Notas |
|---|---|
| Resource Group `AZ500LAB09` | Contenedor de todos los recursos |
| ACR `az500acr<timestamp>` | Nombre único generado en tiempo de ejecución |
| AKS Cluster `MyKubernetesCluster` | 1 nodo, network plugin Azure |
| Deployment `nginxexternal` | 1 réplica, expuesta con Load Balancer público |
| Deployment `nginxinternal` | 1 réplica, expuesta con Load Balancer interno |

## Prerrequisitos

- Azure CLI autenticado: `az login`
- `kubectl` instalado
- Permisos para crear grupos de recursos, ACR, AKS y asignar roles en la suscripción

## Instrucciones

### 1. Dar permisos de ejecución al script

```bash
chmod +x deploy_nginx_aks.sh
```

### 2. Ejecutar el script

```bash
./deploy_nginx_aks.sh
```

> ⏱️ La creación del cluster AKS toma aproximadamente 5 minutos.

El script realiza automáticamente:
1. Crea el Resource Group
2. Registra el proveedor de contenedores
3. Crea el ACR y construye la imagen nginx
4. Crea el cluster AKS
5. Descarga las credenciales del cluster
6. Asocia el ACR al cluster
7. Despliega nginx externo e interno

### 3. Verificar despliegue

```bash
kubectl get pods
kubectl get services
```

### 4. Acceder al nginx externo

```bash
kubectl get service nginxexternal
# Espera a que EXTERNAL-IP muestre una IP (puede tardar 1-2 min)
# Luego abre http://<EXTERNAL-IP> en tu navegador
```

## 🗑️ Limpieza (obligatorio)

```bash
az group delete --name AZ500LAB09 --yes --no-wait
```

## ⚠️ Notas

- El nombre del ACR incluye un timestamp para garantizar unicidad.
- El cluster tiene `--no-ssh-key` — no se puede conectar por SSH a los nodos.
- Si la asignación de rol sobre la VNet falla (entorno sin permisos), el script continúa igual.
