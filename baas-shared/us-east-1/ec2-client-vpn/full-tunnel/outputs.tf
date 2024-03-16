// https://github.com/cloudposse/terraform-aws-vpc
output "subnets" {
  description = "Subnets outputs"
  value       = module.subnets
}

output "ec2_client_vpn" {
  description = "VPN outputs"
  value       = module.ec2_client_vpn
  sensitive = true
}
