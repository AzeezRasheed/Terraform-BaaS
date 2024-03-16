name = "vpc"

cidr = "10.110.0.0/16"

azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

create_database_subnet_group  = false
manage_default_network_acl    = false
manage_default_route_table    = false
manage_default_security_group = false

enable_dns_hostnames = true
enable_dns_support   = true

enable_nat_gateway = true
single_nat_gateway = true

enable_flow_log                      = true
create_flow_log_cloudwatch_log_group = true
create_flow_log_cloudwatch_iam_role  = true
# flow_log_max_aggregation_interval    = 600
