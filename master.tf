resource "aws_instance" "jenkins_master" {
  ami                    = "${var.ami_linux}"
  key_name               = "${var.key_pair}"
  instance_type          = "${var.master_instance_type}"
  subnet_id              = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_master.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags = "${merge(var.tags, var.tags_instances_linux, map("Module", var.module), map("Name", concat(var.name, "-master")), map("Role", "jenkins-master"))}"
}

resource "aws_security_group" "jenkins_master" {
  name = "${var.name}-master"
  description = "Jenkins (${var.name}) master security group"
  vpc_id = "${data.aws_vpc.selected.id}"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${concat(list(aws_security_group.jenkins_admin), var.admin_sg_ids)}"]
    cidr_blocks = ["${var.admin_cidrs}"]
  }

  tags = "${merge(var.tags, map("Module", var.module))}"
}
