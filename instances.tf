resource "aws_key_pair" "jenkins_slaves" {
  key_name = "jenkins_slaves"
  public_key = "${var.jenkins_slaves_pub_key}}"
}

resource "aws_instance" "jenkins_server" {
  ami = "${data.aws_ami.ubuntu.id}"

  key_name = "${var.key_pair}"

  instance_type = "t2.medium"

  subnet_id = "${var.aws_subnet_id}"

  vpc_security_group_ids = ["${aws_security_group.jenkins_server.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags {
    Name = "jenkins-server"
    Module = "${var.module}"
  }
}

resource "aws_instance" "jenkins_slave_linux" {
  ami = "${data.aws_ami.ubuntu.id}"

  key_name = "${var.key_pair}"

  instance_type = "t2.medium"

  subnet_id = "${var.aws_subnet_id}"

  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_linux.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags {
    Name = "jenkins-slave-linux"
    Module = "${var.module}"
  }
}

resource "aws_instance" "jenkins_slave_linux_template" {
  ami = "${data.aws_ami.ubuntu.id}"

  key_name = "${var.key_pair}"

  instance_type = "t2.micro"

  subnet_id = "${var.aws_subnet_id}"

  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_linux.id}"]

  lifecycle {
    ignore_changes = ["ami"]
  }

  tags {
    Name = "jenkins-slave-linux-template"
    Module = "${var.module}"
  }
}

data "template_file" "windows_user_data" {
  template = "${file("templates/windows-user-data.tpl")}"
}

resource "aws_instance" "jenkins_slave_windows" {
  ami = "${data.aws_ami.windows.id}"

  key_name = "${var.key_pair}"

  instance_type = "t2.medium"

  subnet_id = "${var.aws_subnet_id}"

  user_data = "${data.template_file.windows_user_data.rendered}"

  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_windows.id}"]

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

  tags {
    Name = "jenkins-slave-windows"
    Module = "${var.module}"
  }
}

resource "aws_instance" "jenkins_slave_windows_template" {
  ami = "${data.aws_ami.windows.id}"

  key_name = "${var.key_pair}"

  instance_type = "t2.micro"

  subnet_id = "${var.aws_subnet_id}"

  user_data = "${data.template_file.windows_user_data.rendered}"

  vpc_security_group_ids = ["${aws_security_group.jenkins_slave_windows.id}"]

  lifecycle {
    ignore_changes = ["ami", "user_data"]
  }

  tags {
    Name = "jenkins-slave-windows-template"
    Module = "${var.module}"
  }
}
