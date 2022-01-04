provider "aws" {
  region = "ap-southeast-1"
}
data "aws_availability_zones" "available" {}

locals {
  azs = data.aws_availability_zones.available.names
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "learning-vpc"
  cidr = "10.1.0.0/16"
  azs = data.aws_availability_zones.available.names
  public_subnets = ["10.1.101.0/24"]
} 

module "ec2" {
  source = "cloudposse/ec2-instance/aws"
  version = "0.40.0"

  name = "bastion-host"
  instance_type = "t3.small"
  vpc_id = module.vpc.vpc_id
  subnet = module.vpc.public_subnets[0]
  ami = "ami-055d15d9cfddf7bd3"
  ami_owner = "099720109477"
  associate_public_ip_address = true
  monitoring = false
  security_group_rules = [
    {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
]
}
