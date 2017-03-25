data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

data "aws_vpc" "selected" {
  id = "${data.aws_subnet.selected.vpc_id}"
}
