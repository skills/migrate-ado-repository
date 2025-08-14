## Step 3: Migrate Your Repository

Now that you have set up the migration tools and permissions, it's time to migrate your first repository from Azure DevOps to GitHub!

Based on your configuration, you'll be migrating:

- **Azure DevOps**: `{{ ado_url }}/{{ ado_project_name }}/_git/{{ ado_repository_name }}`
- **To GitHub**: `https://github.com/{{ github_org }}/{{ target_github_repo_name }}`

### Data that is Migrated

GitHub Enterprise Importer supports migrating the following repository data from Azure DevOps to GitHub Enterprise Cloud (see [GitHub Docs](https://docs.github.com/migrations/using-github-enterprise-importer/migrating-from-azure-devops-to-github-enterprise-cloud/about-migrations-from-azure-devops-to-github-enterprise-cloud#data-that-is-migrated)):

- **Git source** (including commit history)
- **Pull requests**
- **User history for pull requests**
- **Work item links on pull requests**
- **Attachments on pull requests**
- **Branch policies for the repository** (user-scoped branch policies and cross-repo branch policies are not included)

### ⌨️ Activity: Migrate Your Azure DevOps Repository to GitHub

Now it's time to perform the actual migration! You'll use the `ado2gh` extension to migrate your Azure DevOps repository, preserving all the Git history, pull requests, and other metadata.

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

1. Monitor the migration progress in the terminal output. This can take few minutes

1. When the migration completes, verify the migrated repository and migrated data by checking the following:

   | Component                   | Link                                                                                |
   | --------------------------- | ----------------------------------------------------------------------------------- |
   | **Repository**              | https://github.com/{{ github_org }}/{{ target_github_repo_name }}                   |
   | **Branches**                | https://github.com/{{ github_org }}/{{ target_github_repo_name }}/branches          |
   | **Pull Requests**           | https://github.com/{{ github_org }}/{{ target_github_repo_name }}/pulls             |
   | **Commit History**          | https://github.com/{{ github_org }}/{{ target_github_repo_name }}/commits/main/     |
   | **Branch Protection Rules** | https://github.com/{{ github_org }}/{{ target_github_repo_name }}/settings/branches |

   > 📝 **Note**: Branch Protection Rules may not be visible on free GitHub organizations.

1. Check the [migration log issue](https://github.com/{{ github_org }}/{{ target_github_repo_name }}/issues/2) that was automatically created in the migrated repository for any warnings or errors.

1. With the migration successful, add a comment to this issue to complete the exercise and learn next steps:

   ```md
   Hey @professortocat, I've successfully completed the Migrate Azure DevOps Repository exercise!
   ```

<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure both your ADO_PAT and GH_PAT environment variables are set correctly
- Verify you have the migrator role in your GitHub organization: `{{ github_org }}`
- If migration fails, check the error message and migration logs for details
- You can cancel a migration using `gh ado2gh abort-migration --migration-id MIGRATION-ID`
- Repository names must be unique in the target GitHub organization: `{{ github_org }}`

</details>

### ⌨️ (_Optional_) Activity: Clean Up Resources

After completing the exercise, you may want to clean up the resources that were created during this lab. This step is optional but recommended for keeping your environments tidy.

<details>
<summary>🧹 Show cleanup steps</summary>

1. **Clean up Azure DevOps project**:

   ```bash
   cd ado/project
   terraform apply -destroy -var="ado_token=$ADO_PAT" 
   ```

   You will be asked to confirm by writing `yes`.

1. **Delete the migrated GitHub repository**:

   - Navigate to the migrated repository on GitHub: https://github.com/{{ github_org }}/{{ target_github_repo_name }}
   - Go to repository `Settings` tab
   - Scroll down to the `Danger Zone` and click `Delete this repository`
   - Follow the prompts to confirm deletion

1. **Revoke GitHub migrator role**:

   ```bash
   gh ado2gh revoke-migrator-role --actor {{ login }} --actor-type USER --github-org {{ github_org }}
   ```

1. **Delete Azure DevOps Personal Access Token**:

   - Navigate to your Azure DevOps Organization
   - Find the token you created for this exercise and delete it

</details>
