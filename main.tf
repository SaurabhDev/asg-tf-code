resource "aws_autoscaling_group" "asg" {
  name                      = var.use_dynamic_name
  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
  vpc_zone_identifier       = [data.aws_subnet.default.id]
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  load_balancers            = var.load_balancers
  target_group_arns         = var.target_group_arns
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  placement_group           = var.placement_group
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_template" "lt" {
  name_prefix                 = "${var.use_dynamic_name}-lt"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile {
    arn = var.iam_profile_arn
  }
  key_name                    = var.key_name
  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = [aws_security_group.sg_asg.id]
  }
  user_data                   = base64encode(var.user_data)
  monitoring {
    enabled = var.enable_monitoring
  }
  placement {
    tenancy = var.placement_tenancy
  }
  ebs_optimized               = var.ebs_optimized
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name           = lookup(block_device_mappings.value, "device_name", null)
      no_device             = lookup(block_device_mappings.value, "no_device", null)
      virtual_name          = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(tolist(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = true
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", "alias/aws/ebs")
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

# Make sure it scales when cpu reached above 40%.
resource "aws_autoscaling_policy" "policy" {
  name = "${var.use_dynamic_name}-asg-policy"

  autoscaling_group_name    = aws_autoscaling_group.asg.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = var.estimated_instance_warmup

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_utilization_value
  }

  count = var.scaleinoncpu ? 1 : 0
}

resource "aws_security_group" "sg_asg" {
  name_prefix = "${var.use_dynamic_name}-sg"
  //vpc_id      = "vpc-09383b1f01d572d46"
  vpc_id      = data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }
}
