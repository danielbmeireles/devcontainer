# Azure Resource Naming Conventions

This document provides comprehensive naming convention rules for Azure resources based on Microsoft's Cloud Adoption Framework best practices.

## Table of Contents

- [General Principles](#general-principles)
- [Naming Components](#naming-components)
- [Naming Format](#naming-format)
- [Character and Length Restrictions](#character-and-length-restrictions)
- [Resource Abbreviations](#resource-abbreviations)
- [Scope Considerations](#scope-considerations)
- [Best Practices](#best-practices)

## General Principles

### Resource Name Permanence
- Most Azure resource names **cannot be changed** after creation
- Include only **constant information** in names
- Use **tags** for additional metadata that may change

### Azure Naming Rules
All resource names must:
- Be **unique** within their specific scope
- Meet **length requirements** for the resource type
- Contain only **valid characters** as defined per resource type

### Case Sensitivity
- Most Azure resources are **case-insensitive**
- Use consistent casing throughout your organization (typically lowercase)

## Naming Components

Recommended components to include in resource names:

| Component | Description | Example |
|-----------|-------------|---------|
| Resource Type | Abbreviated resource type | `vm`, `st`, `sql` |
| Workload/Application | Name of workload, application, or project | `navigator`, `payroll`, `sharepoint` |
| Environment | Deployment environment stage | `prod`, `dev`, `qa`, `stage`, `test` |
| Region | Azure region where resource is deployed | `eus`, `wus`, `neu` (optional) |
| Instance | Instance number for multiple resources | `001`, `002` |

### Component Order
Standardize the order of components across your organization. Recommended format:
```
<resource-type>-<workload>-<environment>-<region>-<instance>
```

## Naming Format

### General Format Examples

**Virtual Machine:**
```
vm-sql-prod-001
vm-web-dev-002
```

**Web App:**
```
app-navigator-prod-001
app-ecommerce-stage-001
```

**Storage Account:**
```
stnavigatordata001
stlogsprod001
```
*Note: Storage accounts cannot use hyphens*

**SQL Database:**
```
sqldb-users-prod
sqldb-inventory-dev
```

**Key Vault:**
```
kv-secrets-prod-001
kv-certificates-dev-001
```

### Delimiters
- Use **hyphens (-)** for readability where permitted
- Some resources (like storage accounts) do not allow delimiters
- Be consistent with delimiter usage across resources

## Character and Length Restrictions

### General Character Rules
Most resources allow:
- Lowercase letters (a-z)
- Numbers (0-9)
- Hyphens (-)

Most resources prohibit:
- Special characters: `< > % & : \ ? /`
- Control characters
- Consecutive hyphens
- Starting or ending with hyphens
- Periods at the end

### Length Restrictions by Resource Type

| Resource Type | Min Length | Max Length | Special Notes |
|---------------|------------|------------|---------------|
| Storage Account | 3 | 24 | Lowercase letters and numbers only, globally unique |
| Virtual Machine (Windows) | 1 | 15 | Cannot contain special characters |
| Virtual Machine (Linux) | 1 | 64 | Cannot contain special characters |
| SQL Database | 1 | 128 | Cannot end with period or space |
| Resource Group | 1 | 90 | Alphanumeric, underscore, parentheses, hyphen, period |
| Virtual Network | 2 | 64 | Alphanumeric, underscore, period, and hyphen |
| Key Vault | 3 | 24 | Alphanumeric and hyphens only, globally unique |
| App Service | 2 | 60 | Alphanumeric and hyphens |
| AKS Cluster | 3 | 63 | Alphanumeric, underscore, and hyphen |

### Scope Requirements

**Global Scope** (must be globally unique):
- Storage accounts
- Key vaults
- Container registries
- Azure SQL servers
- Azure Cosmos DB accounts

**Resource Group Scope** (unique within resource group):
- Virtual machines
- Network interfaces
- Disks

**Parent Resource Scope** (unique within parent):
- SQL databases (within SQL server)
- Subnets (within virtual network)

## Resource Abbreviations

### AI + Machine Learning

| Resource Type | Abbreviation |
|---------------|--------------|
| AI Search | `srch` |
| Azure AI Services | `ais` |
| Azure Machine Learning workspace | `mlw` |
| Azure OpenAI Service | `oai` |
| Computer Vision | `cv` |
| Language Service | `lang` |
| Speech Service | `spch` |

### Analytics and IoT

| Resource Type | Abbreviation |
|---------------|--------------|
| Azure Data Factory | `adf` |
| Azure Databricks workspace | `dbw` |
| Azure Digital Twin | `dt` |
| Azure Synapse Analytics workspace | `synw` |
| Event Hubs namespace | `evhns` |
| IoT Hub | `iot` |
| Power BI Embedded | `pbi` |

### Compute and Web

| Resource Type | Abbreviation |
|---------------|--------------|
| App Service plan | `asp` |
| Azure Arc enabled server | `arcs` |
| Batch accounts | `ba` |
| Function app | `func` |
| Virtual machine | `vm` |
| Virtual machine scale set | `vmss` |
| Web app | `app` |

### Containers

| Resource Type | Abbreviation |
|---------------|--------------|
| AKS cluster | `aks` |
| Container registry | `cr` |
| Container instance | `ci` |

### Databases

| Resource Type | Abbreviation |
|---------------|--------------|
| Azure Cosmos DB | `cosmos` |
| Azure SQL Database server | `sql` |
| Azure SQL database | `sqldb` |
| Redis Cache | `redis` |
| PostgreSQL database | `psql` |

### Networking

| Resource Type | Abbreviation |
|---------------|--------------|
| Application gateway | `agw` |
| DNS zone | *Use DNS domain name* |
| Firewall | `afw` |
| Load balancer (internal) | `lbi` |
| Load balancer (external) | `lbe` |
| Network interface | `nic` |
| Network security group | `nsg` |
| Public IP address | `pip` |
| Route table | `rt` |
| Subnet | `snet` |
| Virtual network | `vnet` |
| VPN Gateway | `vpng` |

### Security

| Resource Type | Abbreviation |
|---------------|--------------|
| Azure Bastion | `bas` |
| Key vault | `kv` |
| Managed identity | `id` |

### Storage

| Resource Type | Abbreviation |
|---------------|--------------|
| Storage account | `st` |
| File share | `share` |
| Blob container | `blob` |
| Queue | `queue` |
| Table | `table` |

### Management and Governance

| Resource Type | Abbreviation |
|---------------|--------------|
| Azure Policy definition | `policy` |
| Log Analytics workspace | `log` |
| Resource group | `rg` |

## Scope Considerations

### Global Scope
Resources must be unique across **all of Azure**:
- Storage accounts
- Key vaults
- Azure SQL servers
- Container registries
- Traffic Manager profiles

### Subscription Scope
Resources must be unique within the **subscription**:
- Resource groups
- Policy definitions

### Resource Group Scope
Resources must be unique within the **resource group**:
- Virtual machines
- Availability sets
- Network security groups
- Virtual networks

### Parent Resource Scope
Resources must be unique within the **parent resource**:
- Subnets (within VNet)
- SQL databases (within SQL server)
- Virtual machine disks (within VM)

## Best Practices

1. **Standardize component order** across your organization
2. **Use delimiters** (hyphens) for readability where permitted
3. **Use approved abbreviations** from the resource abbreviations table
4. **Keep names concise** but meaningful
5. **Avoid redundant information** (e.g., don't include "azure" in names)
6. **Document your naming convention** and share with your team
7. **Use tags** for additional metadata that doesn't belong in the name
8. **Consider automation** using tools like the [Azure Naming Tool](https://github.com/mspnp/AzureNamingTool)
9. **Test names** before deploying to production
10. **Be consistent** - follow the same pattern across all resources

### Examples by Environment

**Production Resources:**
```
vm-app-prod-001
sqldb-customers-prod
st-dataprod001
kv-secrets-prod-eus
```

**Development Resources:**
```
vm-app-dev-001
sqldb-customers-dev
st-datadev001
kv-secrets-dev-eus
```

**Staging Resources:**
```
vm-app-stage-001
sqldb-customers-stage
st-datastage001
kv-secrets-stage-eus
```

## References

- [Azure Resource Naming Best Practices](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Azure Resource Name Rules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Azure Resource Abbreviations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
