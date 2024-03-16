variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}

variable "create_iam_role" {
  description = "Flag to indicate whether an IAM Role should be created to grant the proper permissions for AWS Config"
  type        = bool
  default     = false
}

variable "force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
  default     = false
}

variable "global_resource_collector_region" {
  description = "The region that collects AWS Config data for global resources such as IAM"
  type        = string
}

variable "conformance_pack" {
  type        = string
  description = "The URL to a Conformance Pack"
}

variable "conformance_pack_name" {
  type        = string
  description = "The Name to a Conformance Pack"
}

variable "parameter_overrides" {
  type        = map(any)
  description = "A map of parameters names to values to override from the template"
  default     = {}
}

variable "is_logging_account" {
  description = <<-DOC
    Flag to indicate if this instance of AWS Config is being installed into a centralized logging account. If this flag
    is set to true, then the config rules associated with logging in the catalog (loggingAccountOnly: true) will be
    installed. If false, they will not be installed.
    installed.
  DOC
  type        = bool
  default     = false
}

variable "is_global_resource_region" {
  description = <<-DOC
    Flag to indicate if this instance of AWS Config is being installed to monitor global resources (such as IAM). In
    order to save money, you can disable the monitoring of global resources in all but region. If this flag is set to
    true, then the config rules associated with global resources in the catalog (globalResource: true) will be
    installed. If false, they will not be installed.
  DOC
  type        = bool
  default     = false
}
