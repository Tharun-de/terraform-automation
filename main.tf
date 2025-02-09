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

# Okta Provider Configuration
provider "okta" {
  org_name  = "trial-2582192"  # Okta domain without "-admin"
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN1  # Use Terraform variable for security
}

# Create Jira SCIM App in Okta
resource "okta_app_oauth" "jira" {
  label          = "Jira SCIM Provisioning"
  type           = "browser"
  grant_types    = ["authorization_code", "implicit"]
  redirect_uris  = [var.JIRA_SCIM_URL]
  response_types = ["code", "id_token", "token"]

  # Optional: Set app status to active
  status = "ACTIVE"
}

# Configure SCIM Settings via API Call
resource "null_resource" "configure_scim" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X PUT "https://trial-2582192.okta.com/api/v1/apps/${okta_app_oauth.jira.id}" \
      -H "Authorization: SSWS ${var.OKTA_TOKEN1}" \
      -H "Content-Type: application/json" \
      -d '{
        "settings": {
          "app": {
            "baseUrl": "${var.JIRA_SCIM_URL}",
            "apiToken": "${var.JIRA_SCIM_TOKEN}"
          }
        }
      }'
    EOT
  }
}

# Variables for SCIM Configuration
variable "OKTA_TOKEN1" {
  description = "Okta API Token for managing SCIM settings"
  type        = string
  sensitive   = true
}

variable "JIRA_SCIM_URL" {
  description = "SCIM Base URL for Jira"
  type        = string
}

variable "JIRA_SCIM_TOKEN" {
  description = "SCIM API Token for Jira"
  type        = string
  sensitive   = true
}
