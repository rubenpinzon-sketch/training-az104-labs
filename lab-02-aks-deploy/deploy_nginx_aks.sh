#!/bin/bash
set -euo pipefail

# Variables
RG="AZ500LAB09"
LOCATION="eastus"
ACRNAME="az500acr$(date +%s | tail -c 6)"
AKS_CLUSTER_NAME="MyKubernetesCluster"
NODEPOOL_NAME="agentpool"
DNS_PREFIX="MyKubernetesCluster-dns"

echo "==> [1/8] Creando Resource Group: $RG"
az group create --name $RG --location $LOCATION --output table

echo "==> [2/8] Registrando proveedor Microsoft.ContainerRegistry"
az provider register --namespace Microsoft.ContainerRegistry --wait

echo "==> [3/8] Creando ACR: $ACRNAME"
az acr create --resource-group $RG --name $ACRNAME --sku Basic --output table

echo "==> [4/8] Construyendo y subiendo imagen nginx al ACR"
echo "FROM nginx" > /tmp/Dockerfile_nginx
az acr build \
  --resource-group $RG \
  --image sample/nginx:v1 \
  --registry $ACRNAME \
  --file /tmp/Dockerfile_nginx \
  .

echo "==> [5/8] Creando cluster AKS (esto tarda ~5 minutos)"
az aks create \
  --name $AKS_CLUSTER_NAME \
  --resource-group $RG \
  --location $LOCATION \
  --no-ssh-key \
  --node-vm-size Standard_D2s_v3 \
  --nodepool-name $NODEPOOL_NAME \
  --node-count 1 \
  --network-plugin azure \
  --dns-name-prefix $DNS_PREFIX \
  --output table

echo "==> [6/8] Descargando credenciales del cluster"
az aks get-credentials --resource-group $RG --name $AKS_CLUSTER_NAME --overwrite-existing
kubectl get nodes

echo "==> [7/8] Asociando ACR al cluster AKS"
az aks update -n $AKS_CLUSTER_NAME -g $RG --attach-acr $ACRNAME

echo "==> [8/8] Asignando rol Contributor sobre la VNet al identity del cluster"
RG_VNET="MC_${RG}_${AKS_CLUSTER_NAME}_${LOCATION}"
AKS_VNET_NAME=$(az network vnet list --resource-group $RG_VNET --query "[0].name" -o tsv 2>/dev/null || echo "")
if [ -n "$AKS_VNET_NAME" ]; then
  AKS_VNET_ID=$(az network vnet show --name $AKS_VNET_NAME --resource-group $RG_VNET --query id -o tsv)
  AKS_MANAGED_ID=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RG --query identity.principalId -o tsv)
  az role assignment create --assignee $AKS_MANAGED_ID --role "Contributor" --scope $AKS_VNET_ID --output table
else
  echo "  VNet no encontrada en $RG_VNET — se omite la asignacion de rol"
fi

echo "==> Desplegando nginx externo"
sed "s|<ACRUniquename>|$ACRNAME|g" nginxexternal.yaml > /tmp/nginxexternal_rendered.yaml
kubectl apply -f /tmp/nginxexternal_rendered.yaml
kubectl get service nginxexternal

echo "==> Desplegando nginx interno"
sed "s|<ACRUniquename>|$ACRNAME|g" nginxinternal.yaml > /tmp/nginxinternal_rendered.yaml
kubectl apply -f /tmp/nginxinternal_rendered.yaml
kubectl get service nginxinternal

echo ""
echo "==> Deploy completado."
echo "    ACR: ${ACRNAME}.azurecr.io"
echo "    Cluster: $AKS_CLUSTER_NAME"
kubectl get pods
echo ""
echo "Para conectarse a un pod:"
echo "  kubectl exec -it \$(kubectl get pod -l app=nginxexternal -o name | head -1) -- /bin/bash"
echo ""
echo "IP del Load Balancer interno (puede tardar 1-2 min en asignarse):"
echo "  kubectl get service nginxinternal -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"
