variable "OKTA_TOKEN1" {
  description = "Okta API Token for managing users and groups"
  type        = string
  sensitive   = true
}

variable "EMAIL_FILTER" {
  description = "Filter users based on email domain (e.g., company.com)"
  type        = string
  default     = "@company.com"
}
