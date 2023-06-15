# Terraform Script for Managing Infrastructure on Azure

This script allows you to manage infrastructure on Azure using Terraform. It provides various actions to initialize, apply, plan, and more. Below is the breakdown of the script:

## Usage

```shell
./script.sh [ACTION] [ENV] [OTHER OPTIONS]
```

- ACTION: The action to perform. Examples include init, apply, plan, etc.
- ENV: The environment to target. Examples include dev, uat, prod, etc.
- OTHER OPTIONS: Additional options to pass to the Terraform command.

# Actions
- clean: Remove .terraform* folders and tfplan files.
- help: Display help information.
- list: List every available environment.
- summ: Generate a summary of the Terraform plan.
- Other actions: Perform other actions specified by the ACTION parameter.

# Environment

⚠️ Warning: The script expects environment configurations to be stored in the ./env directory. Make sure to create a subdirectory for each environment and include all the necessary configuration files within that subdirectory.

# Prerequisites
- Terraform: Make sure Terraform is installed and available in your system's PATH.
- Azure CLI: The script uses Azure CLI for authentication and interaction with Azure. Make sure Azure CLI is installed and configured properly.

# Usage Examples

- Initialize Terraform for a specific environment:
```shell
./script.sh init dev
```

- Apply Terraform changes for a specific environment:
```shell
./script.sh apply prod
```

- Generate a summary of the Terraform plan for a specific environment:
```shell
./script.sh summ uat
```

# Additional Notes
- The script automatically sets the Azure subscription based on the environment configuration.
- The backend.ini file in the environment directory contains Azure subscription information.
- Ensure you have the necessary permissions and configurations set up before running the script.

Feel free to modify and enhance the README.md to suit your requirements.
