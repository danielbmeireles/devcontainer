#!/bin/bash

# Install additional tools
pip install --user checkov infracost
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Setup shell aliases and functions
cat >> ~/.bashrc << 'EOF'

# Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'
alias tff='terraform fmt -recursive'
alias tfws='terraform workspace select'
alias tfwl='terraform workspace list'

# Terragrunt aliases
alias tg='terragrunt'
alias tgp='terragrunt plan'
alias tga='terragrunt apply'
alias tgd='terragrunt destroy'
alias tgra='terragrunt run-all'

# Azure CLI aliases
alias azl='az login'
alias azll='az account list -o table'
alias azs='az account set --subscription'
alias azsh='az account show'

# Combined validation function
tfcheck() {
    echo "Running Terraform validation pipeline..."
    terraform fmt -check -recursive && \
    terraform validate && \
    tflint && \
    tfsec . && \
    checkov -d . --quiet
}

# Terraform init with backend config
tfinit() {
    terraform init -backend-config="$@"
}

# Quick Terraform plan with color
tfpc() {
    terraform plan -no-color | grep -E '^(Plan:|No changes|.*will be.*)'
}

EOF

echo "Shell setup complete!"
