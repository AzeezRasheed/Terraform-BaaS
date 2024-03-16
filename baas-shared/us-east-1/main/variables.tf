## https://github.com/cloudposse/terraform-aws-s3-log-storage/blob/master/variables.tf
variable "s3_log_storage_acl" {
  type        = string
  default     = "log-delivery-write"
  description = "The canned ACL to apply. We recommend `log-delivery-write` for compatibility with AWS services"
}

variable "s3_log_storage_standard_transition_days" {
  type        = number
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
}

variable "s3_log_storage_glacier_transition_days" {
  type        = number
  default     = 60
  description = "Number of days after which to move the data to the glacier storage tier"
}

variable "s3_log_storage_enable_glacier_transition" {
  type        = bool
  default     = true
  description = "Enables the transition to AWS Glacier which can cause unnecessary costs for huge amount of small files"
}

variable "s3_log_storage_expiration_days" {
  type        = number
  default     = 90
  description = "Number of days after which to expunge the objects"
}
