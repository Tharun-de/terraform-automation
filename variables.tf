variable "OKTA_TOKEN" {
  description = "Okta API Token"
  type        = string
  sensitive   = true
}

variable "JIRA_SCIM_URL" {
  description = "SCIM Base URL for Jira"
  type        = string
  default     = "https://api.atlassian.com/scim/directory/576db93a-153c-45ed-8fce-60d673227148"
}

variable "JIRA_SCIM_TOKEN" {
  description = "SCIM API Token for Jira"
  type        = string
  sensitive   = true
}
