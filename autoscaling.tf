resource "aws_autoscaling_policy" "up" {
  name                   = "scale_up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 500
  autoscaling_group_name = aws_autoscaling_group.sofe_dev_autoscaling_group.name
}

resource "aws_autoscaling_policy" "down" {
  name                   = "scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 500
  autoscaling_group_name = aws_autoscaling_group.sofe_dev_autoscaling_group.name
}

resource "aws_autoscaling_group" "sofe_dev_autoscaling_group" {
  availability_zones = ["us-east-1a"]
  #desired_capacity          = var.DesiredSize
  #max_size                  = var.MaximumSize
  #min_size                  = var.MinimumSize
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = aws_launch_configuration.sofe-dev.id
  vpc_zone_identifier       = data.terraform_remote_state.networking.outputs.public_subnets
}

resource "aws_autoscaling_schedule" "weeknightscheduledaction" {
  scheduled_action_name = "weeknightscheduledaction"
  #desired_capacity       = var.OffPeakDesiredSize
  max_size         = 2
  min_size         = 1
  desired_capacity = 1
  #min_size               = var.OffPeakMinimumSize
  #max_size               = var.OffPeakMaximumSize
  recurrence             = var.WeekNightScheduledActionRecurrence
  autoscaling_group_name = aws_autoscaling_group.sofe_dev_autoscaling_group.name
}

resource "aws_autoscaling_schedule" "weekmorningscheduledaction" {
  scheduled_action_name = "weekmorningscheduledaction"
  #desired_capacity       = var.PeakDesiredSize
  desired_capacity = 1
  max_size         = 2
  min_size         = 1
  #min_size               = var.PeakminimumSize
  #max_size               = var.PeakMaximumSize
  recurrence             = var.WeekMorningScheduledActionRecurrence
  autoscaling_group_name = aws_autoscaling_group.sofe_dev_autoscaling_group.name
}
