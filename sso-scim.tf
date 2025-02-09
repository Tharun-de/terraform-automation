# ✅ Enable SCIM Provisioning for Jira
resource "null_resource" "configure_scim_jira" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X PUT "https://trial-2582192.okta.com/api/v1/apps/0oaonyrhuirAG0D0e697" \
      -H "Authorization: SSWS ${var.OKTA_TOKEN}" \
      -H "Content-Type: application/json" \
      -d '{
        "settings": {
          "app": {
            "baseUrl": "${var.JIRA_SCIM_URL}",
            "apiToken": "${var.JIRA_SCIM_TOKEN}"
          }
        }
      }'
    EOT
  }
}