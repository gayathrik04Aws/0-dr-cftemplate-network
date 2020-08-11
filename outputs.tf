output "aws_launch_configuration" {
  description = "aws_launch_configuration"
  value = {
    "ImageId"            = aws_launch_configuration.sofe-dev.image_id,
    "AutoScalingGroup"   = aws_autoscaling_group.sofe_dev_autoscaling_group.name,
    "PeakDesiredSize"    = var.PeakDesiredSize,
    "PeakMinimumSize"    = var.PeakminimumSize,
    "PeakMaximumSize"    = var.PeakMaximumSize,
    "OffPeakDesiredSize" = var.OffPeakDesiredSize,
    "OffPeakMinimumSize" = var.OffPeakMinimumSize,
    "OffPeakMaximumSize" = var.OffPeakMinimumSize,
  }
}
