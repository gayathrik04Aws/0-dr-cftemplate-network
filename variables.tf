variable "account" {
  description = "Account for organization"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
# variable "subnet_ids" {
#   type = list(string)
# }
variable "iam_instance_profile" {
  default = "sofe"
}
variable "recordset" {
  default = "sofe-dev"
}
variable "ELBAccountID" {
  default = "127311923021"
}
variable "ami_id" {
  type = map
  default = {
    us-east-1 = "ami-0124828d4c59d021b"
  }
}
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "key_name" {
  type    = string
  default = "ec2-dev"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.20.0.0/16"
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "Vpc-custom-demo"
}
#Auto Scaling Properties:
variable "DesiredSize" {
  description = "Enter the Auto Scaling desired group size"
  default     = 1
}
variable "MinimumSize" {
  description = "Enter the Auto Scaling minimum group size"
  type        = number
  default     = 1
}
variable "MaximumSize" {
  description = "Enter the AutoScaling maximum group size."
  type        = number
  default     = 2
}
variable "LowCpuAlarmThreshold" {
  description = "Enter the low CPU alarm threshold."
  type        = number
  default     = 1
}
variable "HighCpuAlarmThreshold" {
  description = "Enter the high CPU alarm threshold"
  type        = number
  default     = 1
}
variable "PeakDesiredSize" {
  type    = number
  default = "9"
}
variable "PeakminimumSize" {
  type    = number
  default = "9"
}
variable "PeakMaximumSize" {
  type    = number
  default = 16
}
variable "OffPeakDesiredSize" {
  type    = number
  default = 3
}
variable "OffPeakMinimumSize" {
  type    = number
  default = 3
}
variable "OffPeakMaximumSize" {
  type    = number
  default = 3
}
variable "WeekNightScheduledActionRecurrence" {
  type        = string
  default     = "0 0 * * 2,3,4,5,6"
  description = "Enter the recurrence for the week-night scheduled action."
}

variable "WeekMorningScheduledActionRecurrence" {
  type        = string
  default     = "0 12 * * 1,2,3,4,5"
  description = "Enter the recurrence for the week-morning scheduled action."
}
variable "input_template_file" {
  default = "PoolConfiguration.xml"
}
