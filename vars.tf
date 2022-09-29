
##### Data-Utils variables ###

##variable "subnet_filter" {
##  description = "Filter subnets by keywords."
##  type = "list"
##  default = ["*"]
##}
##

variable "subnet_type" {
  default = "private"
  description = "The subnet type (public, private, protected)"
}

##### ASG variables ###
variable "max_size" {
  default = 1
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  default = 1
  description = "The minimum size of the auto scale group"
}

variable "desired_capacity" {
  default = 1
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = 300
}

variable "health_check_type" {
  default = "EC2"
  description = "Controls how health checking is done. Values are - EC2 and ELB"
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  default     = false
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers"
  type        = list(string)
  default     = null
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  type        = list(string)
  default     = null
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "placement_group" {
  description = "The name of the placement group into which you'll launch your instances, if any"
  default     = ""
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "min_elb_capacity" {
  description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
  default     = 0
}

variable "wait_for_elb_capacity" {
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior."
  default     = 1
}

variable "protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default     = false
}

variable "use_dynamic_name" {
  description = "Determines whether the ASG name should include a dynamic suffix which deploys new ASG when suffix changes"
  default     = true
}

### LC variables ####

variable "image_id" {
  description = "The EC2 image ID to launch"
}

variable "instance_type" {
  description = "The size of instance to launch"
  default = "t2.medium"
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  default     = false
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring. This is enabled by default."
  default     = false
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = any
  default     = {}
}

/*
variable "block_device_mappings" {
  description = "Mappings of block devices, see https://www.terraform.io/docs/providers/aws/r/launch_template.html#block-devices"
  type        = list(object({
    device_name  = string
    no_device    = bool
    virtual_name = string
    ebs = object({
      delete_on_termination = bool
      encrypted             = bool
      iops                  = number
      kms_key_id            = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
    })
  }))
  default     = [
    {
      device_name = "/dev/sda1"
      no_device    = ""
      virtual_name = ""
      ebs = [
          {
            delete_on_termination = true
            volume_size = 8
          }
      ]
    }
  ]
}
*/
variable "placement_tenancy" {
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'"
  default     = "default"
}

variable "user_data" {
  description = "(Optional) The user data to provide when launching the instance"
  default = ""
}

## ASG POLICY
variable "scaleinoncpu" {
  description = "Set to true if you want asg to scale in on average cpu"
  default = false
}

variable "cpu_utilization_value" {
    default = 40
    description = "CPU percentage to scale at. Default will be 40%"
}

variable "estimated_instance_warmup" {
  default = 180
  description = " (Optional) The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics. Without a value, AWS will default to the group's specified cooldown period."
}

variable "name_prefix" {
  default = "dm-eu-west-2-dev-vpc"
}

variable "subnet_filter" {
  description = "Filter subnets by keywords."
  type = list(string)
  default = ["eu-west-2a"]
}

variable "role_arn" {}

variable "region" {}

variable "iam_profile_arn" {}
