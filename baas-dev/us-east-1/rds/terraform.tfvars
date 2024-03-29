
azs                          = ["us-east-1a", "us-east-1b", "us-east-1c"]
publicly_accessible          = false
storage_encrypted            = true
database_name                = "Aurora_PostgreSQL"
database_user                = "aurora_postgresql"
database_port                = 5432
name                         = "aurora-postgres"
subnet_group_name            = "aurora-postgres"
autoscaling_min_capacity     = 2
autoscaling_max_capacity     = 4
cluster_family               = "aurora-postgresql15"
engine                       = "aurora-postgresql"
engine_version               = "15.3"
cluster_size                 = 3
ca_cert_identifier           = "rds-ca-ecc384-g1"
instance_type                = "db.serverless"
aws_ssm_parameter_name       = "/rds/db_password"
retention_period             = 7
performance_insights_enabled = true
database_route_table_name    = "aurora_route_table"
