# AI Configuration Guide

This file provides guidance to AI coding assistants when working with code in this repository.

## Repository Purpose

This is a template devcontainer configuration repository for Infrastructure as Code (IaC) development, specifically focused on Terraform and Azure. It provides a fully-configured containerized development environment with pre-installed tools and shell enhancements.

## Development Environment

The devcontainer is based on Debian Bookworm and includes:

**Azure Tools:**
- Azure CLI with azure-devops extension
- Azure Terraform extension support

**Infrastructure as Code:**
- Terraform with supporting tools:
  - tflint (linting)
  - terragrunt (orchestration)
  - tfsec (security scanning)
  - terraform-docs (documentation generation)
  - checkov (security and compliance scanning)
  - infracost (cost estimation)

**Development Tools:**
- GitHub CLI (gh)
- PowerShell
- Python (latest)
- Homebrew package manager

**Git Configuration:**
- SSH keys and gitconfig are mounted from host for seamless authentication
- Git settings configured for auto-fetch and smart commits

## Shell Aliases and Functions

The setup script (`.devcontainer/setup.sh`) configures useful aliases:

**Terraform shortcuts:**
- `tf`, `tfi`, `tfp`, `tfa`, `tfd`, `tfv`, `tff` - Common terraform commands
- `tfws`, `tfwl` - Workspace management
- `tfcheck()` - Run complete validation pipeline (fmt, validate, tflint, tfsec, checkov)
- `tfinit()` - Terraform init with backend config
- `tfpc()` - Colorized plan summary

**Terragrunt shortcuts:**
- `tg`, `tgp`, `tga`, `tgd`, `tgra` - Terragrunt commands

**Azure CLI shortcuts:**
- `azl`, `azll`, `azs`, `azsh` - Login, list accounts, set/show subscription

## Working with the Devcontainer

**To use this template:**
1. Clone/fork this repository
2. Open in VS Code with Dev Containers extension
3. Rebuild container using "Dev Containers: Rebuild Container" command

**Modifying the configuration:**
- Configuration file: `.devcontainer/devcontainer.json`
- Setup script: `.devcontainer/setup.sh`
- After changes, rebuild the container

## VS Code Extensions

The devcontainer automatically installs extensions for:
- Terraform development and Azure Terraform integration
- Security scanning (Checkov)
- YAML editing
- PowerShell development
- Git visualization (Git Graph, Git Blame)
- Markdown editing
- Azure DevOps Pipelines