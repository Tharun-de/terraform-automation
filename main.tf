terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.42"
    }
  }
}

provider "tfe" {
  token = var.TFE_TOKEN
}


resource "tfe_organization" "org" {
  name  = "test-automation-org"
  email = "admin@example.com"
}

resource "tfe_workspace" "workspace" {
  name           = "terraform-automation"
  organization   = tfe_organization.org.name
  execution_mode = "remote"

  vcs_repo {
    identifier = "Tharun-de/terraform-automation"
    branch     = "main"
  }
}

variable "TFE_TOKEN" {
  description = "Terraform Enterprise API Token"
  type        = string
}
locals {
  debug_token = var.TFE_TOKEN
}

output "debug_token" {
  value = local.debug_token
}
