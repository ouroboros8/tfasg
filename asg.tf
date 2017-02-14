# Centos7 default
variable "image_id" {
  default = "ami-bb373ddf"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_launch_configuration" "launch_configuration" {
  image_id      = "${var.image_id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudformation_stack" "all_zones_asg" {
  name          = "my-asg"
  template_body = <<EOF
{
  "Resources": {
    "MyAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": {"Fn::GetAZs": "eu-west-2"},
        "LaunchConfigurationName": "${aws_launch_configuration.launch_configuration.name}",
        "MaxSize": 2,
        "MinSize": 2
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "1",
          "MaxBatchSize": "1",
          "PauseTime": "PT0S"
        }
      }
    }
  }
}
EOF
}
