dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "temporary"
    public_outputs = ["temporary"]
  }

}

terraform {
  source = "tfr:///cloudposse/ec2-instance/aws?version=0.40.0"
}

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
  name = "bastion"
  instance_type = "t3.small"

  vpc_id = dependency.vpc.outputs.vpc_id
  subnet = dependency.vpc.outputs.public_subnets[0]

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
