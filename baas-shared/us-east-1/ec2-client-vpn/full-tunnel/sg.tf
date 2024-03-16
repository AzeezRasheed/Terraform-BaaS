// https://registry.terraform.io/modules/cloudposse/security-group/aws/latest
// https://github.com/cloudposse/terraform-aws-security-group
module "security_group" {
  source  = "cloudposse/security-group/aws"
  version = "2.2.0"

  vpc_id = local.baas_shared_vpc_us.vpc_id
  rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTP from anywhere"
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow HTTPS from anywhere"
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow DNS tcp from anywhere"
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "UDP"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow DNS udp from anywhere"
    },
  ]

  context = module.naming.context
}
