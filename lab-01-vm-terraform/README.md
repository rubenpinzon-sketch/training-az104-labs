# Lab 01 — Despliegue de VM Windows con Terraform

## Descripción

Despliega una máquina virtual **Windows 10 (AVD)** en Azure usando **Terraform**,
con red virtual, IP pública, NSG y apagado automático diario.
Incluye pipelines de GitHub Actions para plan, apply y destroy.

## Servicio Azure

**Azure Virtual Machines** — `Standard_D8s_v3`, Windows 10 (win10-22h2-avd)

## Recursos que se crean

| Recurso | Nombre | Notas |
|---|---|---|
| Resource Group | `rgvmwin` | Contenedor de todos los recursos |
| Virtual Network | `vmwin-vnet` | CIDR `10.0.0.0/16` |
| Subnet | `default` | CIDR `10.0.0.0/24` |
| Public IP | `vmwin-ip` | Static, Standard SKU |
| NSG | `vmwin-nsg` | Permite RDP TCP/3389 |
| Network Interface | `vmwin51` | Con accelerated networking |
| Virtual Machine | `vmwin` | Windows 10 AVD, D8s_v3 |
| Auto-shutdown | — | Diario a las 19:00 UTC |

## Prerrequisitos

- Azure CLI autenticado: `az login`
- Terraform ≥ 1.15 instalado
- Suscripción Azure con permisos de Contributor

## Instrucciones

### 1. Configurar variables

```bash
cp terraform.tfvars.example terraform.tfvars
# Edita terraform.tfvars:
# - subscription_id: tu Subscription ID de Azure
# - rdp_source_address: tu IP pública (recomendado) o "*"
```

### 2. Configurar contraseña del administrador

```bash
export TF_VAR_admin_password="$YOUR_SECURE_PASSWORD"
```

> ⚠️ Nunca hardcodees la contraseña en `terraform.tfvars`.

### 3. Inicializar y desplegar

```bash
terraform init
terraform plan -var-file="terraform.tfvars" -out=tfplan
terraform apply tfplan
```

### 4. Conectarse a la VM

```bash
# Obtener IP pública
terraform output public_ip_address

# Conectarse por RDP (Windows/macOS)
mstsc /v:<IP_PUBLICA>
# Usuario: sysadmin
# Contraseña: la que configuraste en TF_VAR_admin_password
```

## 🗑️ Limpieza (obligatorio)

```bash
terraform destroy -var-file="terraform.tfvars"
```

Confirma con `yes` cuando se te solicite.

## GitHub Actions (opcional — avanzado)

Los workflows en `.github/workflows/` automatizan plan/apply/destroy via CI/CD.
Requiere configurar los siguientes secrets en el repositorio de GitHub:

| Secret | Valor |
|---|---|
| `AZURE_CLIENT_ID` | App Registration Client ID |
| `AZURE_CLIENT_SECRET` | App Registration Client Secret |
| `AZURE_TENANT_ID` | Tenant ID de tu directorio |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID |
| `TF_VAR_ADMIN_PASSWORD` | Contraseña del admin de la VM |

## ⚠️ Notas de Seguridad

- El NSG permite RDP desde cualquier IP por defecto (`*`). Restringe `rdp_source_address` a tu IP.
- La contraseña se inyecta via variable de entorno, nunca en archivos `.tf` o `.tfvars`.
- El archivo `terraform.tfvars` está en `.gitignore` — nunca lo commitees.
- El estado de Terraform (`terraform.tfstate`) puede contener datos sensibles. No lo compartas.
