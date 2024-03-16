provider "aws" {
  region = var.region
  alias  = "network"

  # assume_role {
  #   role_arn = ...
  # }
}

provider "aws" {
  region = var.region
  alias  = "baas-prod"

  # assume_role {
  #   role_arn = ...
  # }
}

provider "aws" {
  region = var.region
  alias  = "baas-uat"

  # assume_role {
  #   role_arn = ...
  # }
}

provider "aws" {
  region = var.region
  alias  = "baas-dev"

  # assume_role {
  #   role_arn = ...
  # }
}