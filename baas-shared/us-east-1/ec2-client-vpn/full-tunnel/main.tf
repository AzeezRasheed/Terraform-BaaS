locals {

  baas_shared_vpc_us = data.terraform_remote_state.baas_shared_vpc_us.outputs.vpc

  ipv4_cidr_block = cidrsubnet(local.baas_shared_vpc_us.vpc_cidr_block, 5, 27)

  dns_servers = [cidrhost(local.baas_shared_vpc_us.vpc_cidr_block, 2), "1.1.1.1"]

  additional_routes = [for route in var.additional_routes : {
    destination_cidr_block = "10.150.0.0/16"
    description            = "route.description"
    target_vpc_subnet_id   = element(module.subnets.private_subnet_ids, 0)
  }]

  authorization_rules = [
    {
      name = "All to local"
      authorize_all_groups = true
      description = "All to local"
      target_network_cidr = local.baas_shared_vpc_us.vpc_cidr_block
    },
    {
      name = "All to 0.0.0.0/0"
      authorize_all_groups = true
      description = "All to 0.0.0.0/0"
      target_network_cidr = "0.0.0.0/0"
    },

  ]
}

module "subnets" {
  // https://registry.terraform.io/modules/cloudposse/dynamic-subnets/aws/latest
  // https://github.com/cloudposse/terraform-aws-dynamic-subnets
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones   = var.availability_zones
  vpc_id               = local.baas_shared_vpc_us.vpc_id
  igw_id               = [local.baas_shared_vpc_us.igw_id]
  ipv4_cidr_block      = [local.ipv4_cidr_block]
  max_subnet_count = length(var.availability_zones)
  private_route_table_enabled = false
  public_subnets_enabled = false
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.naming.context
}

module "ec2_client_vpn" {
  // https://registry.terraform.io/modules/cloudposse/ec2-client-vpn/aws/latest
  // https://github.com/cloudposse/terraform-aws-ec2-client-vpn/tree/main
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "1.0.0"

  authentication_type = var.authentication_type

  client_cidr                   = var.client_cidr

  saml_provider_arn             = aws_iam_saml_provider.vpn[0].arn
  self_service_saml_provider_arn = aws_iam_saml_provider.self_service_portal[0].arn

  organization_name             = var.organization_name
  retention_in_days             = var.retention_in_days
  associated_subnets            = module.subnets.private_subnet_ids
  authorization_rules           = local.authorization_rules
  additional_routes             = local.additional_routes
  create_security_group = false
  associated_security_group_ids = [module.security_group.id]
  vpc_id                        = local.baas_shared_vpc_us.vpc_id
  dns_servers                   = local.dns_servers
  split_tunnel                  = var.split_tunnel
  transport_protocol = var.transport_protocol
  self_service_portal_enabled = var.self_service_portal_enabled

  logging_enabled               = true
  logging_stream_name           = var.name

  context = module.naming.context
}