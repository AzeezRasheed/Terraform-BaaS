### GLOBAL VARS
## ============================================================================
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "profile" {
  type        = string
  default     = "baas-dev"
  description = "Profile name from ~/.aws/config file"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = "ez"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = "us-east-1"
  description = "Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = null
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "additional_routes" {
  default     = []
  description = "A list of additional routes that should be attached to the Client VPN endpoint"

  type = list(object({
    destination_cidr_block = string
    description            = string
    target_vpc_subnet_id   = string
  }))
}


## ============================================================================
provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "baas_dev_vpc_us" {
  backend = "s3"
  config = {
    bucket  = "ez-us-east-1-dev-terraform-tfstate-backend"
    key     = "vpc.tfstate"
    profile = "baas-dev"
    region  = "us-east-1"
  }
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones          = var.azs
  vpc_id                      = local.baas_dev_vpc_us.vpc_id
  igw_id                      = [local.baas_dev_vpc_us.igw_id]
  ipv4_cidr_block             = [local.ipv4_cidr_block]
  max_subnet_count            = length(var.azs)
  private_route_table_enabled = false
  public_subnets_enabled      = false
  nat_gateway_enabled         = false
  nat_instance_enabled        = false

  context = module.naming.context
}


locals {
  account_id  = data.aws_caller_identity.current.account_id
  dir_current = basename(path.cwd)

  baas_dev_vpc_us = data.terraform_remote_state.baas_dev_vpc_us.outputs.vpc

  ipv4_cidr_block = cidrsubnet(local.baas_dev_vpc_us.vpc_cidr_block, 5, 27)

  dns_servers = [cidrhost(local.baas_dev_vpc_us.vpc_cidr_block, 2), "1.1.1.1"]

  additional_routes = [for route in var.additional_routes : {
    destination_cidr_block = "10.150.0.0/16"
    description            = "route.description"
    target_vpc_subnet_id   = element(module.subnets.private_subnet_ids, 0)
  }]

  authorization_rules = [
    {
      name                 = "All to local"
      authorize_all_groups = true
      description          = "All to local"
      target_network_cidr  = local.baas_dev_vpc_us.vpc_cidr_block
    },
    {
      name                 = "All to 0.0.0.0/0"
      authorize_all_groups = true
      description          = "All to 0.0.0.0/0"
      target_network_cidr  = "0.0.0.0/0"
    },

  ]
  tags = tomap({
    "Owner"     = tostring(local.account_id),
    "Terraform" = tostring(local.dir_current)
  })
}
## ============================================================================
module "naming" {
  ## This module generates names using the following convention by default: {namespace}-{environment}-{stage}-{name}-{attributes}.
  ## https://registry.terraform.io/modules/cloudposse/label/null/latest
  ## https://github.com/cloudposse/terraform-null-label/blob/master/exports/context.tf
  source  = "cloudposse/label/null"
  version = "0.25.0" # requires Terraform >= 0.13.0

  enabled     = var.enabled
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = var.attributes

  tags = local.tags
}
