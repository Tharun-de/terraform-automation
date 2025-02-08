terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.42"
    }
  }
}

provider "tfe" {
  token = var.TFE_TOKEN
}

resource "tfe_organization" "org" {
  name  = "test-automation-org"
  email = "admin@example.com"
}

resource "tfe_workspace" "workspace" {
  name         = "terraform-automation"
  organization = tfe_organization.org.name
  execution_mode = "remote"
  vcs_repo {
    identifier     = "Tharun-de/terraform-automation" # Replace with your GitHub repo
    branch         = "main"
    oauth_token_id = var.TFE_GITHUB_OAUTH_TOKEN_ID    # Optional: If using GitHub OAuth
  }
}

variable "TFE_TOKEN" {}
variable "TFE_GITHUB_OAUTH_TOKEN_ID" {} # Optional if using GitHub OAuth
 
