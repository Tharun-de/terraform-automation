variable "OKTA_TOKEN1" {
  description = "Okta API Token"
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
