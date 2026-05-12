locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-bastion"
    Role = "bastion"
  })
}

resource "aws_instance" "private_node" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = var.private_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_node_sg_id]
  key_name               = var.key_name

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-private-node"
    Role = "k3s-node"
  })
}
