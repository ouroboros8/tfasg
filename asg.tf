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
  template_body = "${data.template_file.cloudformation_auto_scaling_group.rendered}"
}

data "template_file" "cloudformation_auto_scaling_group" {
  template = "${file("cf.json.tpl")}"

  vars {
    launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
    max_size             = 2
    min_size             = 2
  }
}
