#!/bin/bash

# Script to bootstrap Azure DevOps project using Terraform
# Usage: ./bootstrap.sh --ado-token <token> --ado-url <url>

set -e  # Exit on any error

# Initialize variables
ADO_PAT=""
ADO_URL=""

# Function to display usage
usage() {
    echo "Usage: $0 --ado-token <token> --ado-url <url>"
    echo ""
    echo "Options:"
    echo "  --ado-token <token>      Azure DevOps Personal Access Token (required)"
    echo "  --ado-url <url>          Azure DevOps organization URL (required)"
    echo "  -h, --help              Show this help message"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --ado-token)
            ADO_PAT="$2"
            shift 2
            ;;
        --ado-url)
            ADO_URL="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1"
            usage
            ;;
    esac
done

# Check if required parameters are provided
if [ -z "$ADO_PAT" ]; then
    echo "Error: Azure DevOps Personal Access Token (--ado-token) is required"
    usage
fi

if [ -z "$ADO_URL" ]; then
    echo "Error: Azure DevOps URL (--ado-url) is required"
    usage
fi

# Change to the project directory where terraform files are located
cd "$(dirname "$0")/project"

echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform apply -var="ado_token=$ADO_PAT" -var="ado_url=$ADO_URL" -auto-approve

echo "Bootstrap completed successfully!"
echo "Azure DevOps project has been created and configured."

# Trigger the repository dispatch event to start the next step
echo "Triggering next exercise step..."

gh api repos/:owner/:repo/dispatches \
    --field event_type=start-migration \
    --field client_payload[repository_url]="$ADO_URL"
