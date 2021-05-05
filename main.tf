resource "aws_launch_template" "main" {
  name                    = "${var.env}-${var.name}"
  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized
  user_data               = base64encode(var.instance_userdata)
  image_id                = var.instance_ami
  instance_type           = var.instance_type
  key_name                = var.instance_ssh_key

  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }

  monitoring {
    enabled = var.detailed_monitoring
  }

  placement {
    group_name = aws_placement_group.main.name
  }


  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      tomap({
        Name = "${var.project}-${var.env}-${var.name}"
      })
    )
  }
}

resource "aws_placement_group" "main" {
  name     = "${var.env}-${var.name}"
  strategy = var.placement_strategy
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.project}_${var.env}_${var.name}_profile"
  role = aws_iam_role.main.name
}


resource "aws_iam_role" "main" {
  name               = "${var.project}_${var.env}_${var.name}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "main" {
  count = length(var.iam_role_policy)
  name  = "${var.project}_${var.env}_${var.name}_policy"
  policy = element(var.iam_role_policy, count.index)
  role   = aws_iam_role.main.name
}



resource "aws_iam_role_policy_attachment" "main" {
  count      = length(var.managed_iam_policy)
  role       = aws_iam_role.main.name
  policy_arn = element(var.managed_iam_policy, count.index)
}


resource "aws_autoscaling_group" "main" {
  name                = "${var.project}-${var.env}-${var.name}-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = var.instance_desired_cap
  max_size            = var.instance_max_cap
  min_size            = var.instance_min_cap
  health_check_type   = var.health_check_type
  target_group_arns   = [aws_lb_target_group.main.arn]


  launch_template {
    id      = aws_launch_template.main.id
    version = var.launch_template_version
  }

  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}

resource "aws_lb" "main" {
  name               = "${var.project}-${var.env}-${var.name}-lb"
  load_balancer_type = var.lb_type
  subnets            = var.lb_subnet_ids
  internal           = var.bool_lb_internal
  idle_timeout       = var.lb_idle_timeout

  access_logs {
    bucket  = "${data.aws_caller_identity.current.account_id}-access-logs"
    prefix  = "${var.project}/${var.env}/${var.name}"
    enabled = var.bucket_logs_enabled
  }


  tags = merge(
    local.common_tags,
    tomap({
      Name = "${var.project}-${var.env}-${var.name}"
    })
  )
}


resource "aws_lb_target_group" "main" {
  name_prefix = "${substr(var.name, 0, 4)}-"
  protocol    = var.lb_target_group_proto
  port        = var.lb_target_group_port
  vpc_id      = var.vpc_id
  target_type = var.target_type

  stickiness {
    enabled = var.stickiness_enabled
    type    = var.stickiness_type
  }
  health_check {
    path     = var.healthcheck_path
    protocol = var.healthcheck_protocol
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "main" {
  count             = length(var.lb_listener_port)
  load_balancer_arn = aws_lb.main.arn
  port              = element(var.lb_listener_port, count.index)
  protocol          = element(var.lb_listener_protocol, count.index)
  ssl_policy        = element(var.lb_ssl_security_policy, count.index)
  certificate_arn   = element(var.lb_certificate_arn, count.index)

  default_action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.project}-${var.env}-${var.name}-instance"
  description = "${var.project} ${var.env} ${var.name} instance security group"
  vpc_id      = var.vpc_id


  tags = merge(
    local.common_tags,
    tomap({
      Name = "${var.project}-${var.env}-${var.name}"
    })
  )

}



resource "aws_security_group_rule" "instance_ingress_sg" {
  count                    = length(var.instance_ingress_source_sg) >= 1 ? length(var.instance_ingress_source_sg) : 0
  type                     = "ingress"
  description              = element(var.instance_ingress_sg_rule_description, count.index)
  from_port                = element(var.instance_ingress_sg_from_port, count.index)
  to_port                  = element(var.instance_ingress_sg_to_port, count.index)
  protocol                 = element(var.instance_ingress_sg_proto, count.index)
  source_security_group_id = element(var.instance_ingress_source_sg, count.index)
  security_group_id        = aws_security_group.instance.id
}

resource "aws_security_group_rule" "instance_ingress_cidr" {
  count             = length(var.instance_ingress_cidrblock) >= 1 ? length(var.instance_ingress_cidrblock) : 0
  type              = "ingress"
  description       = element(var.instance_ingress_cidr_rule_description, count.index)
  from_port         = element(var.instance_ingress_cidr_from_port, count.index)
  to_port           = element(var.instance_ingress_cidr_to_port, count.index)
  protocol          = element(var.instance_ingress_cidr_proto, count.index)
  cidr_blocks       = element(var.instance_ingress_cidrblock, count.index)
  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "instance_egress" {
  count             = length(var.instance_egress_cidrblock) >= 1 ? length(var.instance_egress_cidrblock) : 0
  type              = "egress"
  description       = element(var.instance_egress_rule_description, count.index)
  from_port         = element(var.instance_egress_from_port, count.index)
  to_port           = element(var.instance_egress_to_port, count.index)
  protocol          = element(var.instance_egress_proto, count.index)
  cidr_blocks       = [element(var.instance_egress_cidrblock, count.index)]
  security_group_id = aws_security_group.instance.id
}

resource "aws_route53_record" "main" {
  count   = length(var.zone_id) >= 1 ? 1 : 0
  zone_id = var.zone_id
  name    = var.name
  type    = var.r53_record_type
  ttl     = var.r53_ttl
  records = [aws_lb.main.dns_name]
}
