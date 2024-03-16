azs                              = ["us-east-1a", "us-east-1b", "us-east-1c"]
create_sns_topic                 = true
create_iam_role                  = true
force_destroy                    = false
global_resource_collector_region = "us-east-1"


conformance_pack      = "https://raw.githubusercontent.com/awslabs/aws-config-rules/master/aws-config-conformance-packs/Operational-Best-Practices-for-HIPAA-Security.yaml"
conformance_pack_name = "Operational-Best-Practices-for-HIPAA-Security"
