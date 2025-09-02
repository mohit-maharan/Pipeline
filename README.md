```markdown
# 🚀 Azure Resource Deployment with Terraform & GitHub Actions 🤖

Welcome! 🎉 This guide explains how to deploy Azure resources using Terraform, automated with a nifty GitHub Actions CI/CD pipeline. 🤩

## 📝 Overview

This project provides the necessary Terraform configuration and GitHub Actions workflow to automatically provision resources in Microsoft Azure. The pipeline triggers on pushes to the `main` branch, ensuring your infrastructure is always in sync with your code. ☁️💻

## ✨ Prerequisites

Before you begin, make sure you have the following ready:

* **Azure Subscription:** An active Azure account. If you don't have one, get a [free account](https://azure.microsoft.com/free/)! 🆓
* **GitHub Repository:** A GitHub repo to host your Terraform code and the workflow file. 📂
* **Azure CLI:** Installed on your local machine. [Installation Guide](https://docs.microsoft.com/cli/azure/install-azure-cli). 💻
* **Terraform:** Installed locally to test configurations. [Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli). 🛠️
* **Service Principal:** An Azure Service Principal with `Contributor` rights on your subscription. This allows GitHub Actions to authenticate with Azure securely. 🔑

## 📂 Project Structure

Here’s how the project files are organized:

```

.
├── .github/
│   └── workflows/
│       └── main.yml      \# GitHub Actions Workflow ✨
├── main.tf               \# Main Terraform configuration 🏗️
├── variables.tf          \# Terraform variable declarations 📝
├── outputs.tf            \# Terraform outputs 📤
└── terraform.tfvars      \# (Optional) Variable values - DO NOT commit sensitive data\! 🤫

````

## ⚙️ Configuration Steps

Follow these steps to get everything set up! 👇

### 1. Clone the Repository cloning

```bash
git clone <your-repo-url>
cd <your-repo-name>
````

### 2\. Configure Azure Credentials 🔑

A Service Principal is needed for GitHub Actions to securely connect to your Azure subscription.

  * **Create a Service Principal:**
    ```bash
    az ad sp create-for-rbac --name "GitHubActionsTerraform" --role contributor --scopes /subscriptions/<Your-Subscription-ID> --sdk-auth
    ```
  * **Copy the JSON Output:** This command will output a JSON object with your credentials. You'll need this for the next step\!📋
  * **Add GitHub Secret:**
    1.  In your GitHub repository, go to `Settings` \> `Secrets and variables` \> `Actions`.
    2.  Click `New repository secret`.
    3.  Create a secret named `AZURE_CREDENTIALS` and paste the entire JSON output from the previous step as the value.

### 3\. Set Up Terraform Backend 💾

It's best practice to store your Terraform state file in an Azure Storage Account.

  * **Create a Resource Group:**
    ```bash
    az group create --name terraform-state-rg --location "East US"
    ```
  * **Create a Storage Account:**
    ```bash
    az storage account create --name <your-unique-storage-account-name> --resource-group terraform-state-rg --location "East US" --sku Standard_LRS
    ```
  * **Create a Storage Container:**
    ```bash
    az storage container create --name tfstate --account-name <your-storage-account-name>
    ```
  * **Update `main.tf`:** Add the backend configuration block at the top of your `main.tf` file.
    ```terraform
    terraform {
      backend "azurerm" {
        resource_group_name  = "terraform-state-rg"
        storage_account_name = "<your-unique-storage-account-name>"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
      }
    }
    ```

### 4\. Customize Terraform Variables ✏️

Modify `variables.tf` to define the variables your project needs. You can provide default values or create a `terraform.tfvars` file for local testing.

**Example `variables.tf`:**

```terraform
variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "MyWebAppRG"
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
  default     = "East US"
}
```

## 🤖 GitHub Actions Workflow Explained

The `.github/workflows/main.yml` file orchestrates the deployment. Here's a quick breakdown:

  * **Trigger:** The workflow runs on every `push` to the `main` branch.
  * **Jobs:**
      * `terraform_plan`: Initializes Terraform, validates the code, and generates an execution plan. The plan is saved as an artifact. 📄
      * `terraform_apply`: This job depends on the successful completion of the plan. It downloads the plan artifact and applies the changes to your Azure environment. It only runs if the push is to the `main` branch. ✅

## ▶️ Usage & Deployment

1.  **Commit and Push:** Make changes to your `.tf` files.
2.  **Push to `main`:** Push your changes to the `main` branch.
    ```bash
    git add .
    git commit -m "feat: Add new Azure resources ✨"
    git push origin main
    ```
3.  **Check the Action:** Go to the `Actions` tab in your GitHub repository to monitor the pipeline's progress. 🏃‍♂️💨

## 💥 Destroying Resources

To avoid unwanted costs, you can destroy the created resources.

1.  Comment out the `terraform_apply` job in `main.yml`.
2.  Add a new job to run `terraform destroy`.
3.  **Important:** Remember to remove the destroy job afterward to prevent accidental deletion\! 💣

<!-- end list -->

```yaml
  terraform_destroy:
    name: 'Terraform Destroy'
    runs-on: ubuntu-latest
    needs: terraform_plan # Or run it manually
    environment: production

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: 'Terraform Destroy'
      uses: hashicorp/terraform-github-actions@master
      with:
        cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
        tf_actions_version: 1.0.0
        tf_actions_subcommand: 'destroy'
        tf_actions_working_dir: '.'
        tf_actions_comment: true
```

## 🤝 Contributing

We love contributions\! 🎉 If you'd like to help improve this project, you are more than welcome. Here are some guidelines:

### 🐛 Reporting Bugs

If you find a bug, please open an issue and include:

  * A clear title and description of the issue.
  * Steps to reproduce the bug.
  * The expected behavior and what actually happened.

### 💡 Suggesting Enhancements

Have an idea for a new feature or an improvement? Open an issue to start the discussion. We'd love to hear your feedback\!

### 🎉 Submitting Pull Requests

1.  **Fork the repository** to your own GitHub account.
2.  **Clone your fork** to your local machine.
3.  **Create a new branch** for your changes (`git checkout -b feature/your-amazing-feature`).
4.  **Make your changes** and test them to make sure they work as expected.
5.  **Commit your changes** with a clear and descriptive message.
6.  **Push your branch** to your fork on GitHub.
7.  **Open a pull request** back to the original repository.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

-----

Happy Terraforming\! 💖

```

You should be all set now! ✨ Let me know if you need anything else at all! 😊
```
