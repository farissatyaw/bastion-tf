terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.5.0"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "ap-southeast-1"
}
EOF
}

inputs = {
  name = "learning-vpc"
  cidr = "10.1.0.0/16"

  azs  = ["ap-southeast-1a"]
  public_subnets = ["10.1.101.0/24"]
}
