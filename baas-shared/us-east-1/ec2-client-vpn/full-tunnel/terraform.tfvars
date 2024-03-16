name = "ec2-client-vp-full-tunnel"

authentication_type = "federated-authentication"

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]

saml_metadata_document                 = "saml/ec2-client-vpn-full-tunnel.xml"
self_service_portal_saml_metadata_document = "saml/self-service-portal-full-tunnel.xml"

client_cidr                   = "10.225.0.0/21"
transport_protocol = "udp"
organization_name             = "eztech"
logging_enabled               = true
logging_stream_name           = var.logging_stream_name
retention_in_days             = 30
associated_security_group_ids = var.associated_security_group_ids
export_client_certificate     = var.export_client_certificate
dns_servers                   = var.dns_servers
split_tunnel                  = false
self_service_portal_enabled = true
session_timeout_hours = 24