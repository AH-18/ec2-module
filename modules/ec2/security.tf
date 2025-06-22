resource "aws_security_group" "this" {
  name        = "${var.instance_name}-sg"
  description = "Security group for the ${var.instance_name} EC2"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = item

    content {
      from_port       = item.value.from_port
      to_port         = item.value.to_port
      protocol        = item.value.protocol
      cidr_blocks     = length(item.value.cidr_blocks) > 0 ? item.value.cidr_blocks : null
      security_groups = length(item.value.security_groups) > 0 ? item.value.security_groups : null
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    iterator = item

    content {
      from_port   = item.value.from_port
      to_port     = item.value.to_port
      protocol    = item.value.protocol
      cidr_blocks = item.value.cidr_blocks
      description = item.value.description
    }
  }

  tags = merge(local.default_tags, var.tags, {
    Name = "${var.instance_name}-sg"
  })
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_name}-iam-profile"
  role = aws_iam_role.this.name

  tags = merge(local.default_tags, var.tags)
}

resource "aws_iam_role" "this" {
  name = "${var.instance_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.default_tags, var.tags)
}


resource "aws_iam_role_policy_attachment" "ecr_poweruser" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}


resource "aws_iam_policy_attachment" "this" {
  count = length(var.iam_permissions)

  name       = "${var.instance_name}-iam-permissions"
  roles      = [aws_iam_role.this.name]
  policy_arn = var.iam_permissions[count.index]
  depends_on = [aws_iam_role.this]
}