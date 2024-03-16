module "guardduty" {
  #https://github.com/cloudposse/terraform-aws-guardduty
  source           = "cloudposse/guardduty/aws"
  version          = "0.5.0"
  create_sns_topic = var.create_sns_topic
  context          = module.naming.context
}
