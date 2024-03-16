variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}
