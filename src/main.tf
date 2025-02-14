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
    "RDP" = {
      type        = "ingress"
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_launch_template" "main" {
  image_id      = "ami-0aa117785d1c1bfe5"
  #   instance_type = "t2.micro"
  #
  #   network_interfaces {
  #     associate_public_ip_address = true
  #     security_groups             = ["sg-06f3048b18a86b228"]
  #   }
  #
  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_instance" "main" {
  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.default_version
  }
  subnet_id = "subnet-03a25e384bab374ab"

  tags = {
    Name = var.md_metadata.name_prefix
  }

  lifecycle {
    ignore_changes        = [launch_template[0].version]
    create_before_destroy = true
  }
}

resource "aws_security_group" "main" {
  description = "default VPC security group"
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

