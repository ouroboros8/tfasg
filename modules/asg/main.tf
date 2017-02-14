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

resource "aws_cloudformation_stack" "all_zones_asg" {
  name          = "my-asg"
  template_body = "${data.template_file.cloudformation_auto_scaling_group.rendered}"
}

data "template_file" "cloudformation_auto_scaling_group" {
  template = "${file("${path.module}/cf.tpl")}"

  vars {
    region                   = "${var.region}"
    launch_configuration     = "${var.launch_config_name}"
    max_size                 = "${var.max_size}"
    min_size                 = "${var.min_size}"
    min_instances_in_service = "${var.min_instances_in_service}"
    max_batch_size           = "${var.max_batch_size}"
  }
}
