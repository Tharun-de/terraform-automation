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
  org_name  = "trial-2582192"  # Remove the "-admin" part
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN1
}


# HTTP Provider for SCIM API call
provider "http" {}

# SCIM API Call to configure the Jira SCIM app in Okta
resource "null_resource" "configure_scim" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X PUT "https://trial-2582192-admin.okta.com/api/v1/apps/0oaonxeu7xsluLcio697" \
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
resource "okta_app_oauth" "jira" {
  label               = "Jira SCIM Provisioning"
  type                = "browser"
  grant_types         = ["authorization_code", "implicit"]
  redirect_uris       = ["https://api.atlassian.com/scim/directory/576db93a-153c-45ed-8fce-60d673227148"]
  response_types      = ["code", "id_token", "token"]
  token_endpoint_auth_method = "client_secret_basic"
  status              = "ACTIVE"
  sign_on_mode        = "OPENID_CONNECT"

  settings = {
    app = {
      baseUrl = var.JIRA_SCIM_URL
    }
  }

  credentials {
    oauthClient {
      client_id     = "known_after_apply"
      client_secret = "known_after_apply"
    }
  }
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
