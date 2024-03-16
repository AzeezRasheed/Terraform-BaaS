resource "aws_iam_saml_provider" "vpn" {
  count = var.saml_metadata_document != null ? 1 : 0

  name                   = format("%s-vpn", module.naming.id)
  saml_metadata_document = file("${path.root}/${var.saml_metadata_document}")
}

resource "aws_iam_saml_provider" "self_service_portal" {
  count = var.self_service_portal_saml_metadata_document != null ? 1 : 0

  name                   = format("%s-self-service-portal", module.naming.id)
  saml_metadata_document = file("${path.root}/${var.self_service_portal_saml_metadata_document}")
}
