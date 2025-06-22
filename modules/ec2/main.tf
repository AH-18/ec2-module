locals {
  module_name       = "tf/instance"
  module_version    = file("${path.module}/RELEASE")
  module_maintainer = "Cloud Softway"
  default_tags = {
    ModuleName        = local.module_name
    ModuleVersion     = local.module_version
    module_maintainer = local.module_maintainer
  }
}

#tfsec:ignore:aws-ec2-enforce-http-token-imds
resource "aws_instance" "this" {

  ami           = var.ami_id
  instance_type = var.instance_type

  # Security
  key_name               = var.keypair_name
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  # Networking
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.subnet_id

  # Storage
  root_block_device {
    volume_size           = var.root_block_device.size
    volume_type           = var.root_block_device.type
    encrypted             = var.root_block_device.encrypted
    delete_on_termination = var.root_block_device.delete_on_termination
  }

  # General
  tags = merge(local.default_tags, var.tags, {
    Name = var.instance_name
  })
}
