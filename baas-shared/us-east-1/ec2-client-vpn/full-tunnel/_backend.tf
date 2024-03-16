terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "ez-us-east-1-shared-terraform-tfstate-backend"
    key            = "ec2-client-vpn-full-tunnel.tfstate"
    dynamodb_table = "ez-us-east-1-shared-terraform-tfstate-backend-lock"
    profile        = "baas-shared"
    role_arn       = ""
    encrypt        = "true"
  }
}