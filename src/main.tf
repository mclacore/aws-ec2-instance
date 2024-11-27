locals {
  security_group_rules = {
    "HTTP" = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "Allow all outbound traffic" = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    "SSH" = {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = var.md_metadata.name_prefix
  image_id      = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"

  key_name = aws_key_pair.ssh.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main.id]
  }

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_instance" "main" {
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
  subnet_id = element(split("/", var.vpc.data.infrastructure.private_subnets[0].arn), 1)

  tags = {
    Name = var.md_metadata.name_prefix
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "main" {
  name        = "${var.md_metadata.name_prefix}-web-service"
  description = "Web service security group"
  vpc_id      = element(split("/", var.vpc.data.infrastructure.arn), 1)
}

resource "aws_security_group_rule" "main" {
  for_each = local.security_group_rules

  security_group_id = aws_security_group.main.id
  description       = each.key
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.md_metadata.name_prefix}-ssh-key"
  public_key = tls_private_key.ssh.public_key_openssh
}
