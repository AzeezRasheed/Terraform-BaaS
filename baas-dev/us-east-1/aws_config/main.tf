module "config_labels" {
  # https://github.com/cloudposse/terraform-null-label
  source  = "cloudposse/label/null"
  version = "0.22.1"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  delimiter  = "-"

  context = module.naming.context
}

resource "aws_iam_role" "support_role" {
  name = module.config_labels.id

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
}

resource "aws_iam_policy" "support_policy" {
  name        = "${module.config_labels.id}-policy"
  description = "IAM policy for AWS Config support role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "config:Describe*",
          "config:Get*",
          "config:List*"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "support_policy_attach" {
  name       = module.config_labels.id
  roles      = [aws_iam_role.support_role.name]
  policy_arn = aws_iam_policy.support_policy.arn
}


module "cis_rules" {
  # https://github.com/cloudposse/terraform-aws-config/tree/1.1.0/modules/cis-1-2-rules
  source = "cloudposse/config/aws//modules/cis-1-2-rules"

  is_global_resource_region = var.is_global_resource_region
  is_logging_account        = var.is_logging_account
  cloudtrail_bucket_name    = module.cloudtrail_s3_bucket.bucket_id
  parameter_overrides       = var.parameter_overrides
  support_policy_arn        = aws_iam_policy.support_policy.arn
  context                   = module.naming.context
}


module "aws_config_storage" {
  # https://github.com/cloudposse/terraform-aws-config-storage
  source        = "cloudposse/config-storage/aws"
  version       = "1.0.0"
  force_destroy = var.force_destroy
  context       = module.naming.context
}

module "aws_config" {
  # https://github.com/cloudposse/terraform-aws-config
  source = "cloudposse/config/aws"

  create_sns_topic                 = var.create_sns_topic
  create_iam_role                  = var.create_iam_role
  managed_rules                    = module.cis_rules.rules
  force_destroy                    = var.force_destroy
  global_resource_collector_region = var.global_resource_collector_region
  s3_bucket_id                     = module.aws_config_storage.bucket_id
  s3_bucket_arn                    = module.aws_config_storage.bucket_arn
  context                          = module.naming.context
}

module "hipaa_conformance_pack" {
  # https://github.com/cloudposse/terraform-aws-config/tree/1.1.0/modules/conformance-pack
  # https://github.com/cloudposse/terraform-aws-config/tree/0.12.7/modules/conformance-pack
  source = "cloudposse/config/aws//modules/conformance-pack"

  name = var.conformance_pack_name

  conformance_pack    = var.conformance_pack
  parameter_overrides = var.parameter_overrides

  depends_on = [
    module.aws_config
  ]
}

module "cloudtrail_s3_bucket" {
  # https://registry.terraform.io/modules/cloudposse/s3-bucket/aws/latest
  # https://github.com/cloudposse/terraform-aws-cloudtrail-s3-bucket
  source = "cloudposse/cloudtrail-s3-bucket/aws"

  context = module.naming.context
}
