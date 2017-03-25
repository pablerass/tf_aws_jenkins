resource "aws_key_pair" "jenkins_slaves" {
  key_name = "${var.name}-slaves"
  public_key = "${var.slaves_key}"
}

resource "aws_instance" "jenkins_slave_linux" {
  count = "${var.linux_slave_count}"

  ami                    = "${data.aws_ami.ubuntu.id}"
  key_name               = "${var.key_pair}"
  instance_type          = "${var.slave_linux_instance_type}"
  subnet_id              = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_linux.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags = "${merge(var.tags, var.tags_instances_linux, map("Module", var.module), map("Name", concat(${var.name}, "-slave-linux"), map("Role", "jenkins-slave"))}"
}

resource "aws_instance" "jenkins_slave_linux_template" {
  count = "${var.templates ? "1" : "0"}"

  ami                    = "${data.aws_ami.ubuntu.id}"
  key_name               = "${var.key_pair}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_linux.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags = "${merge(var.tags, var.tags_instances_linux, map("Module", var.module), map("Name", concat(${var.name}, "-slave-linux-template"), map("Role", "jenkins-slave"))}"
}


resource "aws_security_group" "jenkins_slave_linux" {
  name        = "${var.name}-slave-linux"
  description = "Jenkins (${van.name} Linux slave"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${concat(list(aws_security_group.jenkins_server.id, aws_security_group.jenkins_admin), var.admin_sg_ids)}"]
    cidr_blocks = ["${var.admin_cidrs}"]
  }

  tags = "${merge(var.tags, map("Module", var.module))}"
}
