data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

resource "aws_launch_configuration" "launch_configuration" {
  name = "test_launch_config"
  image_id = "${data.aws_ami.centos7.id}"
  instance_type = "t2.micro"
}

## Yeah ok need to extract this into a real template

resource "aws_cloudformation_stack" "all_zones_asg" {
  name = "my-asg"
  template_body = "${file("cloudformation_auto_scaling_group.json.tpl")}"
}

