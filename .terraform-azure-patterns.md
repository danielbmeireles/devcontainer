# Terraform on Azure Best Patterns

This guide provides best practices and patterns for working with Terraform on Azure infrastructure.

## Project Structure

```
project/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── networking/
│   ├── compute/
│   └── storage/
├── backend.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── main.tf
```

## Backend Configuration

**Use Azure Storage for remote state:**

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstateXXXXX"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

**Best practices:**
- Store state in a separate subscription/resource group
- Enable versioning on the storage account
- Use access keys stored in Key Vault or environment variables
- Never commit state files to git

## Provider Configuration

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}
```

## Naming Conventions

**Follow Azure naming conventions:**

```hcl
locals {
  # Standard naming: {resource_type}-{app_name}-{environment}-{region}-{instance}
  resource_suffix = "${var.app_name}-${var.environment}-${var.location_short}-${var.instance}"

  naming = {
    resource_group  = "rg-${local.resource_suffix}"
    vnet           = "vnet-${local.resource_suffix}"
    subnet         = "snet-${local.resource_suffix}"
    nsg            = "nsg-${local.resource_suffix}"
    storage        = "st${replace(local.resource_suffix, "-", "")}" # No hyphens
    key_vault      = "kv-${local.resource_suffix}"
  }
}
```

## Tagging Strategy

**Always tag resources for governance:**

```hcl
locals {
  common_tags = {
    Environment     = var.environment
    ManagedBy      = "Terraform"
    CostCenter     = var.cost_center
    Owner          = var.owner
    Project        = var.project_name
    DeploymentDate = timestamp()
  }
}

resource "azurerm_resource_group" "main" {
  name     = local.naming.resource_group
  location = var.location
  tags     = local.common_tags
}
```

## Module Design

**Create reusable, composable modules:**

```hcl
# modules/resource-group/main.tf
resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}

# modules/resource-group/variables.tf
variable "name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# modules/resource-group/outputs.tf
output "id" {
  value = azurerm_resource_group.this.id
}

output "name" {
  value = azurerm_resource_group.this.name
}
```

## Security Best Practices

**1. Use Managed Identities:**
```hcl
resource "azurerm_linux_virtual_machine" "main" {
  # ... other configuration ...

  identity {
    type = "SystemAssigned"
  }
}
```

**2. Store secrets in Key Vault:**
```hcl
data "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_postgresql_server" "main" {
  administrator_login_password = data.azurerm_key_vault_secret.db_password.value
  # ... other configuration ...
}
```

**3. Use Private Endpoints:**
```hcl
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-${local.naming.storage}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}
```

**4. Enable diagnostic settings:**
```hcl
resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${var.resource_name}"
  target_resource_id         = var.resource_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  dynamic "log" {
    for_each = var.log_categories
    content {
      category = log.value
      enabled  = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
```

## Variable Management

**Use variable validation:**

```hcl
variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string

  validation {
    condition     = can(regex("^(eastus|westus|northeurope|westeurope)$", var.location))
    error_message = "Location must be a valid Azure region."
  }
}
```

**Use tfvars files per environment:**

```hcl
# environments/dev/terraform.tfvars
environment  = "dev"
location     = "eastus"
instance     = "01"
vm_size      = "Standard_B2s"
enable_backup = false

# environments/prod/terraform.tfvars
environment  = "prod"
location     = "eastus"
instance     = "01"
vm_size      = "Standard_D4s_v3"
enable_backup = true
```

## Data Sources

**Use data sources for existing resources:**

```hcl
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "shared" {
  name = "rg-shared-${var.environment}"
}

data "azurerm_key_vault" "shared" {
  name                = "kv-shared-${var.environment}"
  resource_group_name = data.azurerm_resource_group.shared.name
}
```

## Conditional Resources

**Use count or for_each for conditional deployments:**

```hcl
resource "azurerm_network_security_group" "main" {
  count = var.create_nsg ? 1 : 0

  name                = local.naming.nsg
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = "snet-${each.key}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value.address_prefix]
}
```

## Dependency Management

**Use explicit dependencies when needed:**

```hcl
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete"]

  # Ensure Key Vault is fully created before applying access policy
  depends_on = [azurerm_key_vault.main]
}
```

## Testing and Validation

**Pre-deployment validation workflow:**

```bash
# 1. Format code
terraform fmt -recursive

# 2. Validate syntax
terraform validate

# 3. Run linting
tflint --recursive

# 4. Security scanning
tfsec .
checkov -d .

# 5. Plan with cost estimation
terraform plan -out=tfplan
infracost breakdown --path tfplan
```

## Common Patterns

**1. Hub-and-Spoke Networking:**
```hcl
# Hub VNet with shared services
module "hub_network" {
  source = "./modules/networking"

  vnet_name     = "vnet-hub-${var.environment}"
  address_space = ["10.0.0.0/16"]
  subnets = {
    firewall = { address_prefix = "10.0.1.0/24" }
    bastion  = { address_prefix = "10.0.2.0/24" }
    shared   = { address_prefix = "10.0.3.0/24" }
  }
}

# Spoke VNet with workload
module "spoke_network" {
  source = "./modules/networking"

  vnet_name     = "vnet-spoke-${var.environment}"
  address_space = ["10.1.0.0/16"]
  subnets = {
    app = { address_prefix = "10.1.1.0/24" }
    db  = { address_prefix = "10.1.2.0/24" }
  }
}

# Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = module.hub_network.resource_group_name
  virtual_network_name      = module.hub_network.vnet_name
  remote_virtual_network_id = module.spoke_network.vnet_id
}
```

**2. Multi-region deployment:**
```hcl
locals {
  regions = ["eastus", "westus"]
}

module "regional_resources" {
  for_each = toset(local.regions)
  source   = "./modules/regional"

  location    = each.value
  environment = var.environment
}
```

## Error Handling

**Use try() for safe value access:**

```hcl
locals {
  subnet_id = try(azurerm_subnet.main[0].id, null)
  tags      = try(merge(var.tags, local.common_tags), local.common_tags)
}
```

## Documentation

**Document modules thoroughly:**

```hcl
# Required: Always include a README.md for each module
# Use terraform-docs to auto-generate documentation:
# terraform-docs markdown table --output-file README.md --output-mode inject .
```

## Useful Commands

```bash
# Initialize with backend config
terraform init -backend-config="key=env-${ENV}.tfstate"

# Plan with specific var file
terraform plan -var-file="environments/${ENV}/terraform.tfvars"

# Apply with auto-approve (CI/CD only)
terraform apply -auto-approve -var-file="environments/${ENV}/terraform.tfvars"

# Import existing resources
terraform import azurerm_resource_group.main /subscriptions/{sub-id}/resourceGroups/{rg-name}

# Refresh state
terraform refresh

# Show current state
terraform show

# List resources in state
terraform state list

# Remove resource from state (doesn't destroy)
terraform state rm azurerm_resource_group.main
```
