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

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

resource "aws_launch_configuration" "launch_configuration" {
  name          = "test_launch_config"
  image_id      = "${data.aws_ami.ubuntu16.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudformation_stack" "all_zones_asg" {
  name          = "my-asg"
  template_body = "${data.template_file.cloudformation_auto_scaling_group.rendered}"
  depends_on    = ["aws_launch_configuration.launch_configuration"]
}

data "template_file" "cloudformation_auto_scaling_group" {
  template = "${file("cloudformation_auto_scaling_group.json.tpl")}"

  vars {
    launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
    max_size             = 2
    min_size             = 2
  }
}
