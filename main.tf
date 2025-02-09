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

# Configure SAML for Jira App in Okta
resource "okta_app_saml" "jira_sso" {
  app_id            = "0oaonyrhuirAG0D0e697"  # Jira App ID from Okta Admin Console
  label             = "Jira Cloud SSO"
  sso_url           = "https://your-jira-instance.atlassian.net/plugins/servlet/saml/acs"
  recipient         = "https://your-jira-instance.atlassian.net/plugins/servlet/saml/acs"
  destination       = "https://your-jira-instance.atlassian.net/plugins/servlet/saml/acs"
  audience          = "https://your-jira-instance.atlassian.net"
  status            = "ACTIVE"

  attribute_statements {
    name       = "email"
    name_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    values     = ["user.email"]
  }

  attribute_statements {
    name       = "firstName"
    name_format = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    values     = ["user.firstName"]
  }

  attribute_statements {
    name       = "lastName"
    name_format = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    values     = ["user.lastName"]
  }
}

# Declare Variables
variable "OKTA_TOKEN1" {
  description = "Okta API Token for managing SAML settings"
  type        = string
  sensitive   = true
}

