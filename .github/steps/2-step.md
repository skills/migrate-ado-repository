## Step 2: Setup GitHub Migration Tools

🎉 **Congratulations!** You've successfully created your new Azure DevOps environment!

Take a moment to explore your Azure DevOps repository:

| Component           | Details                 | Link                                                                                                           |
| ------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------- |
| 📁 **Repository**   | {{ repository_name }}   | [View Repository]({{ ado_repository_url }})                                                                    |
| 🌿 **Branches**     | All repository branches | [View Branches]({{ organization_url }}/{{ project_name }}/\_git/{{ repository_name }}/branches)                |
| 📋 **Work Item**    | Sample work item        | [View Work Item]({{ organization_url }}/{{ project_name }}/\_workitems/edit/{{ update_readme_work_item_id }}/) |
| 🔄 **Pull Request** | Open pull requests      | [View Pull Requests]({{ organization_url }}/{{ project_name }}/\_git/{{ repository_name }}/pullrequests)       |

This Azure DevOps environment contains sample repository, work items, a pull request and other components you will be migrating to GitHub. Feel free to browse around and familiarize yourself with the structure before we begin the migration process.

Now let's set up the GitHub migration tools to prepare for migrating this Azure DevOps project to GitHub.

### ⌨️ Activity: Setup GitHub Personal Access Token

The GitHub token provided in this codespace has limited scopes. For migration operations and extension installation, we need a token with broader permissions including `admin:org` access. Exact scopes required can be found in the [GitHub Docs](https://docs.github.com/migrations/using-github-enterprise-importer/migrating-from-azure-devops-to-github-enterprise-cloud/managing-access-for-a-migration-from-azure-devops#personal-access-tokens-for-github).

> [!IMPORTANT]
> You must be an **owner** of a GitHub organization to perform migrations. If you don't have your own organization, you can [create a personal organization for free](https://docs.github.com/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch).

1. First, unset the existing token and authenticate with GitHub CLI using the required scopes for migration and extension installation:

   ```bash
   unset GITHUB_TOKEN
   gh auth login --scopes "repo,admin:org,workflow"
   ```

1. Follow the interactive prompts to authenticate (choose HTTPS for Git operations when prompted).
1. Verify authentication by running `gh auth status`.

<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure you have admin permissions in your GitHub organization
- If your organization uses SAML SSO, authorize the token for SSO after creation
- Keep the token secure and never share it publicly
- You can only use classic personal access tokens, not fine-grained tokens for migrations
- If `gh auth login` fails, try the manual token creation method

</details>

### ⌨️ Activity: Download ado2gh Extension

1. Install the ado2gh extension by running the following command:

   ```bash
   gh extension install github/gh-ado2gh
   ```

1. Test that the extension is working by running:

   ```bash
   gh ado2gh --help
   ```

<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure you have GitHub CLI version 2.4.0 or newer installed
- If you get permission/SAML errors, check that you're logged into GitHub CLI with `gh auth status` with proper scopes from the previous activity.

</details>

### ⌨️ Activity: Setup GitHub Migrator Role

1. Set `GH_PAT` environment variable

   ```bash
   export GH_PAT=$(gh auth token)
   ```

1. Run the following command to grant the migrator role:

   Replace `YOUR_ORG_NAME` with the GitHub organization name you want to migrate repositories to.

   ```bash
   gh ado2gh grant-migrator-role --actor {{ login }} --actor-type USER --github-org YOUR_ORG_NAME
   ```



1. Verify the role was granted successfully by checking the command output. You should see a message like:

   ```bash
   [yyyy-MM-dd HH:mm:ss] [INFO] Migrator role successfully set for the USER "{{ login }}"
   ```

<details>
<summary>Having trouble? 🤷</summary><br/>

- You need organization owner permissions to grant the migrator role
- The migrator role allows importing/exporting any repository in the organization
- You can revoke the migrator role later using the `revoke-migrator-role` command

</details>

### ⌨️ Activity: Update Migration Configuration

Now let's prepare the migration configuration so we can generate a ready-to-use migration command for you in the next step.

1. Open the `ado/config.yml` file in this repository.

1. Add the following two lines to the configuration file:

   ```yaml
   github_org: "GITHUB_ORG_NAME_PLACEHOLDER"
   target_github_repo_name: "migrated-repo"
   ```

   1. Replace `GITHUB_ORG_NAME_PLACEHOLDER` with the name of your GitHub organization (the same one you used in the previous activity).

   1. You can customize `target_github_repo_name` to whatever you'd like to call the migrated repository.

1. Commit and push your changes to the configuration file. Mona will provide you with the next step!

> [!NOTE]
> We only use these configuration values to prepare the exact migration command you'll need in the next step.
