module "vpc" {
  ## https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  ## https://github.com/terraform-aws-modules/terraform-aws-vpc
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  # name = module.naming.name

  cidr = var.cidr
  azs = var.azs

  private_subnets = [for k, v in var.azs : cidrsubnet(var.cidr, 7, k + 4)]
  public_subnets  = [for k, v in var.azs : cidrsubnet(var.cidr, 7, k + 104)]

  # private_subnet_names = [for k, v in var.azs : "${var.name}-private-${substr(v, -2, -1)}"]
  # public_subnet_names = [for k, v in var.azs : "public-${v}"]

  create_database_subnet_group  = var.create_database_subnet_group
  manage_default_network_acl    = var.manage_default_network_acl
  manage_default_route_table    = var.manage_default_route_table
  manage_default_security_group = var.manage_default_security_group

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role

  vpc_tags = module.naming.tags
  dhcp_options_tags = module.naming.tags
  public_acl_tags = merge(module.naming.tags, {"Name"="${module.naming.id}-private"})
  private_acl_tags = merge(module.naming.tags, {"Name"="${module.naming.id}-public"})
  igw_tags = module.naming.tags
  nat_gateway_tags = module.naming.tags
  nat_eip_tags = module.naming.tags
  vpc_flow_log_tags = module.naming.tags
  private_route_table_tags = merge(module.naming.tags, {"Name"="${module.naming.id}-private"})
  public_route_table_tags = merge(module.naming.tags, {"Name"="${module.naming.id}-public"})
  private_subnet_tags_per_az = {for az in var.azs : az => merge(module.naming.tags, {"Name"="${module.naming.id}-private-use${substr(az, -2, -1)}"}) }
  public_subnet_tags_per_az = {for az in var.azs : az => merge(module.naming.tags, {"Name"="${module.naming.id}-public-use${substr(az, -2, -1)}"}) }

}


# module "vpc" {
#   ## https://registry.terraform.io/modules/cloudposse/vpc/aws/latest
#   ## https://github.com/cloudposse/terraform-aws-vpc
#   source  = "cloudposse/vpc/aws"
#   version = "2.1.0"

#   ipv4_primary_cidr_block = var.ipv4_primary_cidr_block

#   context = module.naming.context
  
# }

# module "private_subnets" {
#   ## https://registry.terraform.io/modules/cloudposse/dynamic-subnets/aws/latest
#   ## https://github.com/cloudposse/terraform-aws-dynamic-subnets
#   source  = "cloudposse/dynamic-subnets/aws"
#   version = "2.4.1"

#   availability_zones  = var.availability_zones
#   max_subnet_count    = length(var.availability_zones)
#   vpc_id              = module.vpc.vpc_id
#   igw_id              = [module.vpc.igw_id]
#   ipv4_cidr_block     = var.ipv4_cidr_block
#   private_subnets_enabled = true
#   public_subnets_enabled = false
#   nat_gateway_enabled = var.nat_gateway_enabled

#   context = module.naming.context
# }


# module "public_subnets" {
#   ## https://registry.terraform.io/modules/cloudposse/dynamic-subnets/aws/latest
#   ## https://github.com/cloudposse/terraform-aws-dynamic-subnets
#   source  = "cloudposse/dynamic-subnets/aws"
#   version = "2.4.1"

#   availability_zones  = var.availability_zones
#   max_subnet_count    = length(var.availability_zones)
#   vpc_id              = module.vpc.vpc_id
#   igw_id              = [module.vpc.igw_id]
#   ipv4_cidr_block     = var.ipv4_cidr_block
#   private_subnets_enabled = var.private_subnets_enabled
#   public_subnets_enabled = var.public_subnets_enabled
#   nat_gateway_enabled = var.nat_gateway_enabled

#   context = module.naming.context
# }

