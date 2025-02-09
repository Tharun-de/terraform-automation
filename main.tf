terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 3.0"
    }
  }
}

provider "okta" {
  org_name  = "trial-2582192" # Example: "dev-123456"
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN
}
resource "okta_app_oauth" "jira" {
  label         = "Jira Cloud"
  type          = "browser"
  grant_types   = ["authorization_code", "implicit"]
  redirect_uris = ["https://tharunpilli01-1733868957997.atlassian.net/jira/your"]
  response_types = ["code", "id_token", "token"]
  post_logout_redirect_uris = ["https://tharunpilli01-1733868957997.atlassian.net/jira/your/logout"]
}
