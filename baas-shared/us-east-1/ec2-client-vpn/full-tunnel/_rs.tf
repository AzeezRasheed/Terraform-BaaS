data "terraform_remote_state" "baas_shared_vpc_us" {
  backend = "s3"
  config = {
    bucket  = "ez-us-east-1-shared-terraform-tfstate-backend"
    key     = "vpc.tfstate"
    profile = "baas-shared"
    region  = "us-east-1"
  }
}

