variable "launch_config_name" {}

variable "max_size" {}

variable "min_size" {}

variable "min_instances_in_service" {}

variable "max_batch_size" {
  default = 1
}

variable "region" {
  default = "eu-west-2"
}

resource "aws_cloudformation_stack" "multi_zone_rolling_upgrade_asg" {
  name = "my-asg"

  template_body = <<EOF
{
  "Resources": {
    "MyAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": {"Fn::GetAZs": "${var.region}"},
        "LaunchConfigurationName": "${var.launch_config_name}",
        "MaxSize": ${var.max_size},
        "MinSize": ${var.min_size}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": ${var.min_instances_in_service},
          "MaxBatchSize": ${var.max_batch_size}
        }
      }
    }
  }
}
EOF
}
