## Step 3: Migrate Your Repository

Now that you have set up the migration tools and permissions, it's time to migrate your first repository from Azure DevOps to GitHub!

### ⌨️ Activity: Run the migrate-repo command

1. Set your GitHub Personal Access Token as an environment variable using the token you authenticated with in Step 2:

   ```bash
   export GH_PAT=$(gh auth token)
   ```

1. Set your Azure DevOps Personal Access Token as an environment variable:

   ```bash
   export ADO_PAT="your_ado_token_here"
   ```

1. Run the migration command using the ado2gh extension:

   ```bash
   gh ado2gh migrate-repo \
     --ado-org YOUR_ADO_ORG \
     --ado-team-project YOUR_TEAM_PROJECT \
     --ado-repo ADO_REPO_NAME \
     --github-org YOUR_GITHUB_ORG \
     --github-repo NEW_REPO_NAME
   ```

  Replace the placeholders with your actual values:
   - `YOUR_ADO_ORG`: Azure DevOps organization name
   - `YOUR_TEAM_PROJECT`: Team project name (e.g., "MigrateFromADO")
   - `ADO_REPO_NAME`: Current repository name in Azure DevOps
   - `YOUR_GITHUB_ORG`: Target GitHub organization
   - `NEW_REPO_NAME`: Desired repository name in GitHub

1. Monitor the migration progress in the terminal output.

1. When the migration completes, verify the migrated repository by visiting the new GitHub repository URL.

1. Check the migration log issue that was automatically created in the migrated repository for any warnings or errors.

<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure both your ADO_PAT and GH_PAT environment variables are set correctly
- Verify you have the migrator role in your GitHub organization
- Check that the Azure DevOps repository exists and you have access to it
- If migration fails, check the error message and migration logs for details
- You can cancel a migration using `gh ado2gh abort-migration --migration-id MIGRATION-ID`
- Repository names must be unique in the target GitHub organization

</details>
