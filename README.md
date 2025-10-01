# DevContainer

A development container configuration optimized for **Infrastructure as Code (IaC)** and **Azure cloud development**.

## Development Capabilities

This devcontainer is designed for:

### Infrastructure as Code
- **Terraform**: Complete Terraform development with formatting, validation, and linting
- **Terragrunt**: Multi-environment Terraform orchestration
- **Azure Infrastructure**: Specialized tooling for Azure resource provisioning

### Cloud Platforms
- **Azure**: Full Azure CLI integration with DevOps extensions
- **GitHub**: GitHub CLI for repository and workflow management

### Security & Compliance
- **Checkov**: Infrastructure security and compliance scanning
- **tfsec**: Terraform-specific security analysis
- **Infracost**: Cloud cost estimation for infrastructure changes

### Scripting & Automation
- **Python**: Latest Python runtime for scripting and automation
- **PowerShell**: Cross-platform PowerShell for Azure automation
- **Bash**: Full bash scripting support with pre-configured aliases

## Features

- Pre-configured development environment
- Pre-commit hooks for code quality
- Terraform tooling integration
- Security scanning with Checkov and tfsec
- Cost analysis with Infracost
- Git configuration and SSH key mounting

## Getting Started

1. Open this repository in VS Code
2. When prompted, reopen in container
3. The devcontainer will build and configure automatically

## Installed Tools & Extensions

### CLI Tools
- Terraform (with tflint, tfsec, terraform-docs)
- Terragrunt
- Azure CLI (with azure-devops extension)
- GitHub CLI
- PowerShell
- Python (latest)
- Homebrew
- Checkov
- Infracost

### VS Code Extensions
- Terraform (HashiCorp)
- Azure Terraform
- Azure Pipelines
- Azure CLI Tools
- Checkov
- Python
- PowerShell
- YAML
- Git Graph
- Git Blame
- Markdown All in One

## Pre-configured Aliases

The devcontainer includes helpful aliases for common operations:

### Terraform
- `tf` - terraform
- `tfi` - terraform init
- `tfp` - terraform plan
- `tfa` - terraform apply
- `tfd` - terraform destroy
- `tfv` - terraform validate
- `tff` - terraform fmt -recursive
- `tfws` - terraform workspace select
- `tfwl` - terraform workspace list

### Terragrunt
- `tg` - terragrunt
- `tgp` - terragrunt plan
- `tga` - terragrunt apply
- `tgd` - terragrunt destroy
- `tgra` - terragrunt run-all

### Azure CLI
- `azl` - az login
- `azll` - az account list -o table
- `azs` - az account set --subscription
- `azsh` - az account show

### Custom Functions
- `tfcheck` - Runs complete validation pipeline (fmt, validate, tflint, tfsec, checkov)
- `tfinit` - Terraform init with backend config support
- `tfpc` - Terraform plan compact output

## Pre-commit Hooks

This project uses pre-commit hooks to ensure code quality. The hooks include:

- YAML and JSON validation
- Merge conflict detection
- Large file detection
- Private key detection
- Terraform formatting and validation
- Terraform linting with tflint
- Security scanning with tfsec
- Infrastructure documentation with terraform-docs
- Static code analysis with Checkov

To install the pre-commit hooks:

```bash
pre-commit install
```

To run manually:

```bash
pre-commit run --all-files
```
