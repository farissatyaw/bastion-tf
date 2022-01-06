resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  version = "1.0.0"

  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  depends_on = [
    tls_private_key.this
  ]
  content = tls_private_key.this.private_key_pem
  filename = "bastion-key"
  file_permission = "600"
}
