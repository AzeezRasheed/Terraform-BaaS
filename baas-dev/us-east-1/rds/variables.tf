variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "database_route_table_name" {
  description = "Name of the database route table"
  type        = string
}

variable "subnet_group_name" {
  description = "Database subnet group name. Will use generated label ID if not supplied."
  type        = string
  default     = ""
}

variable "serverlessv2_scaling_configuration" {
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default     = null
  description = "serverlessv2 scaling properties"
}


variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_user" {
  description = "Username for the database"
  type        = string
}

variable "database_port" {
  description = "Port for the database"
  type        = number
}

variable "aws_ssm_parameter_name" {
  description = "Name of aws ssm parameter"
  type        = string
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the RDS instance"
  type        = string
}

variable "cluster_family" {
  description = "Name of the database cluster family"
  type        = string
}


variable "publicly_accessible" {
  description = "Make the RDS instance publicly accessible"
  type        = bool
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of instances to be maintained by the autoscaler"
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 5
  description = "Maximum number of instances to be maintained by the autoscaler"
}

variable "zone_id" {
  type        = any
  default     = []
  description = <<-EOT
    Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.
    If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.
    Can also be a plain string, but that use is DEPRECATED because of Terraform issues.
    EOT
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}
variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights"
}

variable "ca_cert_identifier" {
  type        = string
  description = "The identifier of the CA certificate for the DB instance"
  default     = null
}
