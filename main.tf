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
  api_token = var.OKTA_TOKEN1
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

# ✅ Create New Employee in Okta
resource "okta_user" "new_employee" {
  first_name  = "John"
  last_name   = "Doe"
  login       = "john.doe@example.com"
  email       = "john.doe@example.com"
  password    = "RandomPassword123!"  # Or use a generated password
  status      = "ACTIVE"
}

# ✅ Assign User to Developers Group
resource "okta_group_membership" "developer_assignment" {
  group_id = okta_group.developers.id
  user_id  = okta_user.new_employee.id
}

# ✅ Assign User to HR Group (Example)
resource "okta_group_membership" "hr_assignment" {
  group_id = okta_group.hr.id
  user_id  = okta_user.new_employee.id
}
