module "s3_log_storage" {
  ## https://registry.terraform.io/modules/cloudposse/s3-log-storage/aws/latest
  ## https://github.com/cloudposse/terraform-aws-s3-log-storage
  source  = "cloudposse/s3-log-storage/aws"
  version = "1.4.2"

  name = "${var.name}-logs"

  force_destroy             = false
  acl                       = var.s3_log_storage_acl
  expiration_days           = var.s3_log_storage_expiration_days
  enable_glacier_transition = var.s3_log_storage_enable_glacier_transition
  glacier_transition_days   = var.s3_log_storage_glacier_transition_days
  standard_transition_days  = var.s3_log_storage_standard_transition_days

  context = module.naming.context
}

module "tfstate_backend" {
  ## https://registry.terraform.io/modules/cloudposse/tfstate-backend/aws/latest
  ## https://github.com/cloudposse/terraform-aws-tfstate-backend
  source  = "cloudposse/tfstate-backend/aws"
  version = "1.1.1"

  name = var.name
  
  force_destroy                      = false
  profile                            = var.profile
  terraform_state_file               = "${local.dir_current}.tfstate"
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "_backend.tf"

  logging = [{
    target_bucket = module.s3_log_storage.bucket_id
    target_prefix      = "tfstate/"
  }]

  context = module.naming.context
}
