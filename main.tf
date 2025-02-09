terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 4.13.1"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0"
    }
  }
}

# Okta Provider
provider "okta" {
  org_name  = "trial-2582192-admin"  # Your Okta Org Name
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN1       # Securely using Terraform variable
}

# HTTP Provider for SCIM API call
provider "http" {}

# SCIM API Call to configure the Jira SCIM app in Okta
resource "http_request" "configure_scim" {
  url    = "https://trial-2582192-admin.okta.com/api/v1/apps/0oaonxeu7xsluLcio697"
  method = "PUT"

  headers = {
    Authorization = "SSWS ${var.OKTA_TOKEN1}"  # Securely using Terraform variable
    Content-Type  = "application/json"
  }

  body = jsonencode({
    settings = {
      app = {
        baseUrl = var.JIRA_SCIM_URL  # SCIM Base URL stored securely
        apiToken = var.JIRA_SCIM_TOKEN  # SCIM API Token stored securely
      }
    }
  })
}

# Declare Terraform Variables (No Hardcoded Secrets)
variable "OKTA_TOKEN1" {
  description = "Okta API Token for making SCIM configuration changes"
  type        = string
}

variable "JIRA_SCIM_URL" {
  description = "SCIM Base URL for Jira"
  type        = string
}

variable "JIRA_SCIM_TOKEN" {
  description = "SCIM API Token for Jira integration"
  type        = string
  sensitive   = true  # Marks the variable as sensitive in Terraform
}
