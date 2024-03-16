resource "random_password" "rds_random_password" {
  length  = 20
  special = false
}

resource "aws_ssm_parameter" "db_password_param" {
  name        = var.aws_ssm_parameter_name
  description = "The database password parameter"
  type        = "SecureString"
  value       = random_password.rds_random_password.result

  tags = {
    environment = var.environment
  }
}

module "aurora_postgres_sg" {
  #https://github.com/cloudposse/terraform-aws-security-group/
  source     = "cloudposse/security-group/aws"
  attributes = ["postgres"]

  # Allow unlimited egress
  allow_all_egress = true

  rules = [
    {
      type        = "ingress"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null
      description = "Allow TCP Ingress on port 5432"
    },

  ]

  vpc_id = local.baas_dev_vpc_us.vpc_id

  context = module.naming.context
}

resource "aws_route_table" "custom_route_table" {
  vpc_id = local.baas_dev_vpc_us.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.baas_dev_vpc_us.igw_id
  }

  tags = {
    Name = var.database_route_table_name
  }
}

resource "aws_route_table_association" "subnet_aws_route_table_associations" {
  for_each = { for idx, subnet_id in module.subnets.private_subnet_ids : idx => subnet_id }

  subnet_id      = each.value
  route_table_id = aws_route_table.custom_route_table.id
}

module "rds_cluster_aurora_postgres" {
  #https://github.com/cloudposse/terraform-aws-rds-cluster
  source = "cloudposse/rds-cluster/aws"

  subnets = module.subnets.private_subnet_ids

  name                     = var.name
  engine                   = var.engine
  engine_version           = var.engine_version
  cluster_family           = var.cluster_family
  cluster_size             = var.cluster_size
  namespace                = var.namespace
  stage                    = var.stage
  admin_user               = var.database_user
  admin_password           = random_password.rds_random_password.result
  db_name                  = var.database_name
  db_port                  = var.database_port
  instance_type            = var.instance_type
  vpc_id                   = local.baas_dev_vpc_us.vpc_id
  security_groups          = [module.aurora_postgres_sg.id]
  zone_id                  = var.zone_id
  subnet_group_name        = var.subnet_group_name
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  serverlessv2_scaling_configuration = {
    max_capacity = var.autoscaling_max_capacity
    min_capacity = var.autoscaling_min_capacity
  }
  storage_encrypted                = var.storage_encrypted
  publicly_accessible              = var.publicly_accessible
  retention_period                 = var.retention_period
  performance_insights_enabled     = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports  = ["postgresql"]
  rds_monitoring_interval          = 15
  enhanced_monitoring_role_enabled = true
  ca_cert_identifier               = var.ca_cert_identifier
}
