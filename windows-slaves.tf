resource "aws_instance" "jenkins_slave_windows" {
  count = "${var.windows_slave_count}"

  ami                    = "${data.aws_ami.windows.id}"
  key_name               = "${var.key_pair}"
  instance_type          = "${var.windows_slave_instance_type}"
  subnet_id              = "${var.aws_subnet_id}"
  user_data              = "${file("files/windows-user-data")}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_windows.id}"]

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

  tags = "${merge(var.tags, var.tags_instances_windows, map("Module", var.module), map("Name", concat(${var.name}, "-slave-windows"), map("Role", "jenkins-slave"))}"
}

resource "aws_instance" "jenkins_slave_windows_template" {
  count = "${var.templates ? "1" : "0"}"

  ami                    = "${var.ami_windows}"
  key_name               = "${var.key_pair}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.aws_subnet_id}"
  user_data              = "${file("files/windows-user-data")}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_windows.id}"]

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

  tags = "${merge(var.tags, var.tags_instances_windows, map("Module", var.module), map("Name", concat(${var.name}, "-slave-windows"), map("Role", "jenkins-slave-template"))}"
}


resource "aws_security_group" "jenkins_slave_windows" {
  name        = "${var.name}-slave-windows"
  description = "Jenkins ($var.name) Windows slave"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port = 135
    to_port = 135
    protocol = "tcp"
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  ingress {
    from_port = 139
    to_port = 139
    protocol = "tcp"
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  ingress {
    from_port = 445
    to_port = 445
    protocol = "tcp"
    security_groups = ["${concat(list(aws_security_group.jenkins_server.id, aws_security_group.jenkins_admin), var.admin_sg_ids)}"]
    cidr_blocks = ["${var.admin_cidrs}"]
  }

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    security_groups = ["${concat(list(aws_security_group.jenkins_server.id, aws_security_group.jenkins_admin), var.admin_sg_ids)}"]
    cidr_blocks = ["${var.admin_cidrs}"]
  }

  ingress {
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  tags = "${merge(var.tags, map("Module", var.module))}"
}
