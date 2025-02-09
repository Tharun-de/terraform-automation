terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 4.13.1"
    }
  }
}

# Okta Provider Configuration
provider "okta" {
  org_name  = "trial-2582192"  # Your Okta domain (without "-admin")
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN1  # Securely using Terraform variable
}

# Apply SCIM Provisioning Settings to Existing Jira App in Okta
resource "null_resource" "configure_scim" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X PUT "https://trial-2582192.okta.com/api/v1/apps/0oaonyrhuirAG0D0e697" \
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

# Declare Required Terraform Variables
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
