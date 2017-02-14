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

module "asg" {
  source                   = "./modules/asg"
  launch_config_name       = "${aws_launch_configuration.launch_configuration.name}"
  max_size                 = 2
  min_size                 = 2
  min_instances_in_service = 1
}
