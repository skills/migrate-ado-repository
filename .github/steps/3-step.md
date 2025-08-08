## Step 3: Migrate Your Repository

Now that you have set up the migration tools and permissions, it's time to migrate your first repository from Azure DevOps to GitHub!

Based on your configuration, you'll be migrating:

- **Azure DevOps**: `{{ ado_url }}/{{ ado_project_name }}/_git/{{ ado_repository_name }}`
- **To GitHub**: `https://github.com/{{ github_org }}/{{ target_github_repo_name }}`

### ⌨️ Activity: Run the migrate-repo command

1. Set your GitHub Personal Access Token as an environment variable using the token you authenticated with in previous step.

   ```bash
   export GH_PAT=$(gh auth token)
   ```

1. Set your Azure DevOps Personal Access Token as an environment variable:

   ```bash
   export ADO_PAT="your_ado_token_here"
   ```

{% if "dev.azure.com" in ado_url %}

1. Run the migration command using the `ado2gh` extension with your configured values:

   ```bash
   gh ado2gh migrate-repo \
     --ado-org {{ ado_url | replace("https://dev.azure.com/", "") }} \
     --ado-team-project {{ ado_project_name }} \
     --ado-repo {{ ado_repository_name }} \
     --github-org {{ github_org }} \
     --github-repo {{ target_github_repo_name }}
   ```

{% else %}

1. Run the migration command using the `ado2gh` extension with your configured values:

   Replace `ADO_ORG_NAME` AND `ADO_SERVER_URL` with your actual values.

   ```bash
   gh ado2gh migrate-repo \
     --ado-server-url ADO_SERVER_URL \
     --ado-org ADO_ORG_NAME \
     --ado-team-project {{ ado_project_name }} \
     --ado-repo {{ ado_repository_name }} \
     --github-org {{ github_org }} \
     --github-repo {{ target_github_repo_name }}
   ```

{% endif %}

This command will migrate:

- **From**: `{{ ado_url }}/{{ ado_project_name }}/_git/{{ ado_repository_name }}`
- **To**: `https://github.com/{{ github_org }}/{{ target_github_repo_name }}`

1. Monitor the migration progress in the terminal output.

1. When the migration completes, verify the migrated repository by visiting: `https://github.com/{{ github_org }}/{{ target_github_repo_name }}`

1. Check the migration log issue that was automatically created in the migrated repository for any warnings or errors.

1. With the migration successful, add a comment to this issue to learn next steps

   ```md
   Hey @professortocat, I've migrated my repository! What's next?
   ```


<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure both your ADO_PAT and GH_PAT environment variables are set correctly
- Verify you have the migrator role in your GitHub organization: `{{ github_org }}`
- If migration fails, check the error message and migration logs for details
- You can cancel a migration using `gh ado2gh abort-migration --migration-id MIGRATION-ID`
- Repository names must be unique in the target GitHub organization: `{{ github_org }}`

</details>
