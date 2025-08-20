#!/bin/bash

# Script to bootstrap Azure DevOps project using Terraform
# Usage: ./bootstrap.sh --ado-token <token>

set -e  # Exit on any error

# Check if running in GitHub Codespaces
if [ -z "$CODESPACES" ] && [ -z "$CODESPACE_NAME" ]; then
    echo "❌ Error: This script must be run in a GitHub Codespace."
    echo ""
    echo "This exercise requires GitHub Codespaces to provide the necessary environment"
    echo "and pre-configured tools for Azure DevOps migration."
    echo ""
    echo "Please:"
    echo "1. Open this repository in GitHub Codespaces"
    echo "2. Run this script again from the Codespace terminal"
    echo ""
    exit 1
fi


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
            echo "❌ Error: Unknown option $1"
            usage
            ;;
    esac
done

# Check if required parameters are provided
if [ -z "$ADO_PAT" ]; then
    echo "❌ Error: Azure DevOps Personal Access Token (--ado-token) is required"
    usage
fi

# Change to the project directory where terraform files are located
cd "$(dirname "$0")/project"

echo "🔄 Initializing Terraform..."
terraform init

echo "🔄 Applying Terraform configuration..."
terraform apply -var="ado_token=$ADO_PAT" -auto-approve

echo "✅ Azure DevOps project has been created and configured."

echo "🔍 Checking for existing pull request..."
export AZURE_DEVOPS_EXT_PAT="$ADO_PAT"

# Get values from Terraform outputs
PROJECT_NAME=$(terraform output -raw project_name)
REPOSITORY_NAME=$(terraform output -raw repository_name)
UPDATED_BRANCH=$(terraform output -raw updated_branch)
ORGANIZATION_URL=$(terraform output -raw organization_url)
WORK_ITEM_ID=$(terraform output -raw update_readme_work_item_id)
REPOSITORY_URL=$(terraform output -raw repository_url)

# Check if pull request already exists (if script was ran multiple times)
EXISTING_PR=$(az repos pr list \
  --source-branch "$UPDATED_BRANCH" \
  --target-branch "main" \
  --repository "$REPOSITORY_NAME" \
  --project "$PROJECT_NAME" \
  --org "$ORGANIZATION_URL" \
  --query "[0].pullRequestId" \
  --output tsv 2>/dev/null || echo "")
  

if [ -n "$EXISTING_PR" ] && [ "$EXISTING_PR" != "null" ]; then
    echo "✅ Pull request already exists with ID: $EXISTING_PR"
    echo "⏭️  Skipping PR and comment creation."
    PR_ID="$EXISTING_PR"
else
    # Create a sample pull request in the Azure DevOps repository
    echo "🔄 Creating new pull request..."
    PR_OUTPUT=$(az repos pr create \
      --source-branch "$UPDATED_BRANCH" \
      --target-branch "main" \
      --title "Update README documentation" \
      --description "Sample pull request created during bootstrap for migration exercise" \
      --repository "$REPOSITORY_NAME" \
      --project "$PROJECT_NAME" \
      --org "$ORGANIZATION_URL" \
      --work-items "$WORK_ITEM_ID" 2>/dev/null || echo '{"pullRequestId": null}')

    # Extract PR ID from the output
    PR_ID=$(echo "$PR_OUTPUT" | jq -r '.pullRequestId // empty')

    if [ -n "$PR_ID" ] && [ "$PR_ID" != "null" ]; then
        echo "✅ Pull request created successfully with ID: $PR_ID"
        
        # Add a comment to the pull request using the REST API
        echo "🔄 Adding comment to pull request..."
        
        # Create a temporary file with the comment payload
        TEMP_FILE=$(mktemp)
        cat > "$TEMP_FILE" <<EOF
{
  "comments": [
    {
      "parentCommentId": 0,
      "content": "🚀 **Bootstrap Complete!**\\n\\nThis PR was created automatically during the Azure DevOps migration exercise.\\n\\n**Details:**\\n- Work Item: #$WORK_ITEM_ID\\n- Repository: $REPOSITORY_URL\\n- Branch: $UPDATED_BRANCH → main\\n\\nPlease review and merge when ready! 🎉",
      "commentType": "text"
    }
  ],
  "status": "active"
}
EOF
        
        az devops invoke \
          --area git \
          --resource pullRequestThreads \
          --organization "$ORGANIZATION_URL" \
          --route-parameters \
            project="$PROJECT_NAME" \
            repositoryId="$REPOSITORY_NAME" \
            pullRequestId="$PR_ID" \
          --http-method POST \
          --in-file "$TEMP_FILE" \
          --api-version "7.0" > /dev/null || true
        
        # Clean up the temporary file
        rm -f "$TEMP_FILE"
        
        echo "✅ Comment added to pull request."
    else
        echo "❌ Pull request creation failed or PR ID could not be retrieved."
        exit 1
    fi
fi

# Trigger the repository dispatch event to start the next step
echo "🚀 Triggering next exercise step on $GITHUB_REPOSITORY repository ..."

gh api repos/$GITHUB_REPOSITORY/dispatches \
    --field event_type=start-migration \
    --field client_payload[ado_repository_url]="$REPOSITORY_URL" \
    --field client_payload[organization_url]="$ORGANIZATION_URL" \
    --field client_payload[project_name]="$PROJECT_NAME" \
    --field client_payload[repository_name]="$REPOSITORY_NAME" \
    --field client_payload[update_readme_work_item_id]="$WORK_ITEM_ID"
