resource "tls_private_key" "example" {
  algorithm = var.ssh_algorithm
  rsa_bits  = var.ssh_rsa_bits
}

resource "aws_key_pair" "deployer" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.example.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.example.public_key_openssh
}
