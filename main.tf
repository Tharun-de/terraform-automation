terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = ">= 4.13.1"
    }
  }
}

# ✅ Okta Provider Configuration
provider "okta" {
  org_name  = "trial-2582192"  # Your Okta domain (without "-admin")
  base_url  = "okta.com"
  api_token = var.OKTA_TOKEN
}

# ✅ Create Okta RBAC Groups
resource "okta_group" "admins" {
  name        = "Admins"
  description = "Full access to all enterprise apps"
}

resource "okta_group" "developers" {
  name        = "Developers"
  description = "Access to Jira and AWS"
}

resource "okta_group" "hr" {
  name        = "HR"
  description = "Access to Azure and HR tools"
}

# ✅ Assign Users to Groups Based on Role
resource "okta_user" "new_employee" {
  first_name  = "John"
  last_name   = "Doe"
  login       = "john.doe@example.com"
  email       = "john.doe@example.com"
  group_ids   = [okta_group.developers.id]  # Assign to Developers
}

# ✅ Assign Groups to Enterprise Apps (Jira, AWS, Azure)
resource "okta_group_memberships" "jira_access" {
  group_id = okta_group.developers.id  # Jira access for Developers
  users    = [okta_user.new_employee.id]
}

resource "okta_group_memberships" "aws_access" {
  group_id = okta_group.developers.id  # AWS access for Developers
  users    = [okta_user.new_employee.id]
}
