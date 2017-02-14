data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-bb373ddf"]
  }
}

data "aws_ami" "ubuntu16" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-ede2e889"]
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  image_id      = "${data.aws_ami.centos7.id}"
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
          "MinInstancesInService": "2",
          "MaxBatchSize": "1",
          "PauseTime": "PT0S"
        }
      }
    }
  }
}
EOF
}
