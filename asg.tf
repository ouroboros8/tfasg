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
  parameters    = {
    LaunchConfiguration = "${aws_launch_configuration.launch_configuration.name}"
  }
  template_body = "${data.template_file.cloudformation_auto_scaling_group.rendered}"
}

data "template_file" "cloudformation_auto_scaling_group" {
  vars {
    max_size = 0
    min_size = 0
  }

  template = <<EOF
    {
      "Parameters": {
        "LaunchConfiguration": {
          "Type": "String",
          "Description": "The name of the LaunchConfiguration to be used by this AutoScalingGroup."
        }
      },
      "Resources": {
        "MyAsg": {
          "Type": "AWS::AutoScaling::AutoScalingGroup",
          "Properties": {
            "AvailabilityZones": {"Fn::GetAZs": "eu-west-2"},
            "LaunchConfigurationName": { "Ref": "LaunchConfiguration" },
            "MaxSize": $${max_size},
            "MinSize": $${min_size}
          }
        }
      }
    }
  EOF
}
