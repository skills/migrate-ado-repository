## Step 2: Setup GitHub Migration Tools

🎉 **Congratulations!** Your Azure DevOps project has been successfully created and is now available at: [{{ ado_repository_url }}]({{ ado_repository_url }})

Now let's set up the GitHub migration tools to prepare for migrating repositories from Azure DevOps to GitHub.

### ⌨️ Activity: Setup GitHub Personal Access Token

1. Authenticate with GitHub CLI using the required scopes for migration and extension installation:

   ```bash
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

1. Update the extension to the latest version:

   ```bash
   gh extension upgrade github/gh-ado2gh
   ```

1. Test that the extension is working by running `gh ado2gh --version`.

<details>
<summary>Having trouble? 🤷</summary><br/>

- Make sure you have GitHub CLI version 2.4.0 or newer installed
- If you get permission/SAML errors, check that you're logged into GitHub CLI with `gh auth status` with proper scopes from the previous activity.

</details>

### ⌨️ Activity: Setup GitHub Migrator Role

1. Identify the GitHub organization you want to migrate repositories to.
1. Decide whether to grant the migrator role to yourself or a team (teams are recommended).
1. Run the following command to grant the migrator role:

   ```bash
   gh ado2gh grant-migrator-role --actor {{ login }} --actor-type USER --github-org YOUR_ORG_NAME
   ```

1. Replace `YOUR_ORG_NAME` with your GitHub organization name.
1. Verify the role was granted successfully by checking the command output.

<details>
<summary>Having trouble? 🤷</summary><br/>

- You need organization owner permissions to grant the migrator role
- The migrator role allows importing/exporting any repository in the organization
- You can revoke the migrator role later using the `revoke-migrator-role` command

</details>
