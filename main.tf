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
  api_token = var.OKTA_TOKEN1  # ✅ Uses the correct token
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

# ✅ Assign YOUR Okta User to Developers Group
resource "okta_group_memberships" "developer_assignment" {
  group_id = okta_group.developers.id
  users    = ["00uooahsz3DQfYyFU697"]  # ✅ Fixed syntax (list format)
}

# ✅ Assign YOUR Okta User to HR Group
resource "okta_group_memberships" "hr_assignment" {
  group_id = okta_group.hr.id
  users    = ["00uooahsz3DQfYyFU697"]  # ✅ Fixed syntax (list format)
}
