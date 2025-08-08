## Step 1: Setting up your Azure DevOps Environment

### ⌨️ Activity: Login to Codespace

Let's start up our project environment. This lab will be ran entirely from within a GitHub Codespace.

1. Use the below button to open the **Create Codespace** page in a new tab. Use the default configuration.

   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/{{full_repo_name}}?quickstart=1)

1. Wait a moment for Visual Studio Code to load in your browser.

1. In the left sidebar, click the extensions tab and verify that the `Terraform` extension is installed and enabled.



### ⌨️ Activity: Create Azure DevOps Personal Access Token

1. Navigate to your Azure DevOps organization in a new browser tab.
1. Click on your profile picture in the top right corner.
1. Select "Personal access tokens" from the dropdown menu.
1. Click "New Token" to create a new personal access token.
1. Give your token a descriptive name (e.g., "Migration Exercise").
1. Set the expiration date to at least 30 days from now.
1. Under "Scopes", select "Full access" or customize with the required permissions.
   <!-- > TODO: Change this later -->
1. Click "Create" and copy the generated token immediately.
1. Store the token securely as you won't be able to see it again.


### ⌨️ Activity: Run Bootstrap Script

1. Run the bootstrap script with your Azure DevOps information.:

   ```bash
   ./ado/bootstrap.sh --ado-token "YOUR_TOKEN_HERE" --ado-url "https://dev.azure.com/<YOUR_ORGANIZATION>"
   ```

1. Watch the script output as it initializes and applies the Terraform configuration.
1. Wait for the script to complete successfully.

<details>
<summary>Having trouble? 🤷</summary><br/>

- Double-check that your token and organization URL are correct
- If you get permission errors, verify your token has the right scopes and run the command again

</details>
