locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_security_group" "public" {
  name        = "${local.name_prefix}-public-sg"
  description = "Public SG for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-public-sg"
  })
}

resource "aws_security_group" "private" {
  name        = "${local.name_prefix}-private-sg"
  description = "Private SG only accepts inbound from public SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "All traffic from public SG"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-private-sg"
  })
}
