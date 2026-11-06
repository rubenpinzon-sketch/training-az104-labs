variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rgvmwin"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus3"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "sysadmin"
}

variable "admin_password" {
  description = "Administrator password for the VM — inject via TF_VAR_admin_password, never hardcode"
  type        = string
  sensitive   = true
}

# SECURITY NOTE: default is '*' (matches ARM template) — restrict to your public IP in production
# Example: rdp_source_address = "203.0.113.10/32"
variable "rdp_source_address" {
  description = "Source IP/CIDR allowed for RDP (TCP/3389). Use your public IP instead of '*'."
  type        = string
  default     = "*"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project     = "az-vm-win"
    environment = "dev"
    owner       = "your-github-username"
    managed_by  = "Terraform"
  }
}
