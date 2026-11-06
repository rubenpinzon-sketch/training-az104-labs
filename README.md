# 🎓 Training AZ-104 Labs — Microsoft Azure Administrator

Materiales de laboratorio para el curso **Microsoft Azure Administrator (AZ-104)**.  
Cada laboratorio es independiente y está diseñado para ejecutarse en un ambiente controlado o de prueba de concepto (POC).

---

## 📋 Laboratorios Incluidos

| # | Laboratorio | Servicio Azure | Herramienta |
|---|---|---|---|
| 01 | [Despliegue de VM Windows con Terraform](./lab-01-vm-terraform/README.md) | Virtual Machine (Windows 10 AVD) | Terraform + GitHub Actions |
| 02 | [Despliegue de AKS con nginx](./lab-02-aks-deploy/README.md) | Azure Kubernetes Service + ACR | Bash script + kubectl |
| 03 | [Sitio web estático en Storage Account](./lab-03-static-storage/README.md) | Storage Account (Static Website) | Azure CLI / Portal |

---

## ✅ Prerrequisitos Generales

- Cuenta Azure activa con permisos de **Contributor** o superior en la suscripción
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) instalado y autenticado (`az login`)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) ≥ 1.15 (solo Lab 01)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado (solo Lab 02)
- Sesión de terminal con Bash (Linux, macOS o WSL en Windows)

> 💡 Se recomienda usar una suscripción sandbox o de desarrollo. **No ejecutar en ambientes de producción.**

---

## 🚀 Cómo Usar Este Repositorio

1. Clona el repositorio:
   ```bash
   git clone https://github.com/rubenpinzon-sketch/training-az104-labs.git
   cd training-az104-labs
   ```
2. Navega al laboratorio que deseas ejecutar.
3. Lee el `README.md` de ese laboratorio antes de comenzar.
4. Sigue las instrucciones paso a paso.
5. **Al terminar: elimina los recursos para evitar costos inesperados.**

---

## 🗑️ Limpieza de Recursos

Cada laboratorio incluye instrucciones para eliminar todos los recursos creados.  
**Es obligatorio ejecutar la limpieza al finalizar cada lab.**  
Los recursos de Azure generan costos mientras estén activos.

---

## ⚠️ Aviso Legal / Disclaimer

> **IMPORTANTE:** Estos archivos son materiales educativos desarrollados exclusivamente para fines de entrenamiento y aprendizaje.
>
> - Deben ejecutarse **únicamente en ambientes controlados, sandboxes o entornos de prueba de concepto (POC)**.
> - **No se recomienda** su uso en ambientes de producción sin revisión y adaptación previa por parte de un profesional certificado.
> - Los archivos han sido auditados y no contienen información sensible, credenciales, tokens de acceso, ni datos personales.
> - **El autor no se hace responsable** de daños, costos, pérdida de datos u otros perjuicios derivados del uso o ejecución de estos materiales.
> - El uso de estos laboratorios implica la aceptación de estos términos.

---

## 📄 Licencia

Este repositorio es de uso libre para fines educativos y de entrenamiento.  
Consulta el archivo [LICENSE](./LICENSE) si está disponible.

---

*Desarrollado para el curso Microsoft Azure Administrator (AZ-104).*
