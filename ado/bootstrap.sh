#!/bin/bash

# Script to bootstrap Azure DevOps project using Terraform
# Usage: ./bootstrap.sh --ado-token <token>

set -e  # Exit on any error

# Initialize variables
ADO_PAT=""

# Function to display usage
usage() {
    echo "Usage: $0 --ado-token <token>"
    echo ""
    echo "Options:"
    echo "  --ado-token <token>      Azure DevOps Personal Access Token (required)"
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

# Change to the project directory where terraform files are located
cd "$(dirname "$0")/project"

echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform apply -var="ado_token=$ADO_PAT" -auto-approve

echo "Bootstrap completed successfully!"
echo "Azure DevOps project has been created and configured."

# Create a sample pull request in the Azure DevOps repository
echo "Creating sample pull request..."
export AZURE_DEVOPS_EXT_PAT="$ADO_PAT"

# Get values from Terraform outputs
PROJECT_NAME=$(terraform output -raw project_name)
REPOSITORY_NAME=$(terraform output -raw repository_name)
UPDATED_BRANCH=$(terraform output -raw updated_branch)
ORGANIZATION_URL=$(terraform output -raw organization_url)
WORK_ITEM_ID=$(terraform output -raw update_readme_work_item_id)
REPOSITORY_URL=$(terraform output -raw repository_url)

az repos pr create \
  --source-branch "$UPDATED_BRANCH" \
  --target-branch "main" \
  --title "Update README documentation" \
  --description "Sample pull request created during bootstrap for migration exercise" \
  --repository "$REPOSITORY_NAME" \
  --project "$PROJECT_NAME" \
  --org "$ORGANIZATION_URL" \
  --work-items "$WORK_ITEM_ID" > /dev/null || true

echo "Sample pull request creation attempted."

# Trigger the repository dispatch event to start the next step
echo "Triggering next exercise step on $GITHUB_REPOSITORY repository ..."

gh api repos/$GITHUB_REPOSITORY/dispatches \
    --field event_type=start-migration \
    --field client_payload[ado_repository_url]="$REPOSITORY_URL" \
    --field client_payload[organization_url]="$ORGANIZATION_URL" \
    --field client_payload[project_name]="$PROJECT_NAME" \
    --field client_payload[repository_name]="$REPOSITORY_NAME" \
    --field client_payload[update_readme_work_item_id]="$WORK_ITEM_ID"
