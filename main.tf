terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 4.13.1"
    }
  }
}


# Create an Okta SCIM App for Jira
resource "okta_app_saml" "jira_scim" {
  label                = "Jira SCIM Provisioning"
  sso_url              = "https://tharunpilli01-1733868957997.atlassian.net/jira/your"
  recipient            = "https://tharunpilli01-1733868957997.atlassian.net/jira/your"
  destination          = "https://tharunpilli01-1733868957997.atlassian.net/jira/your"
  audience             = "urn:okta:scim"
  status               = "ACTIVE"
}

# SCIM API Integration
resource "okta_app_api_integration" "jira_scim_api" {
  app_id       = okta_app_saml.jira_scim.id
  base_url     = "https://api.atlassian.com/scim/directory/576db93a-153c-45ed-8fce-60d673227148"  # Your SCIM Base URL
  bearer_token = var.JIRA_SCIM_TOKEN  # Use a Terraform variable instead
}


# SCIM User Attribute Mapping
resource "okta_app_user_schema" "jira_user_mapping" {
  app_id        = okta_app_saml.jira_scim.id
  index         = "email"
  title         = "Email"
  external_name = "urn:ietf:params:scim:schemas:core:2.0:User:email"
  type          = "string"
}
variable "JIRA_SCIM_TOKEN" {
  description = "SCIM API Token for Jira integration"
  type        = string
}
