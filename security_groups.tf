resource "aws_security_group" "jenkins_server" {
  name = "jenkins_server"
  description = "Jenkins server security group"

  vpc_id = "${var.aws_vpc_id}"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = ["${data.aws_security_group.openvpn.id}"]
  }

  tags {
    Name = "jenkins-server"
    Module = "${var.module}"
  }
}

// TODO: Make security groups more precise, do not use default
// security group, for example
resource "aws_security_group" "jenkins_slave_windows" {
  name = "jenkins_slave_windows"
  description = "Allows Jenkins Windows access"

  vpc_id = "${var.aws_vpc_id}"

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
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  ingress {
    from_port = 1024
    to_port = 65535
    protocol = "tcp"
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  tags {
    Name = "jenkins-slave-windows"
    Module = "${var.module}"
  }
}

resource "aws_security_group" "jenkins_slave_linux" {
  name = "jenkins_slave_linux"

  description = "Allows Jenkins Linux access"

  vpc_id = "${data.aws_vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.jenkins_server.id}"]
  }

  tags {
    Name = "jenkins-slave-linux"
    Module = "${var.module}"
  }
}
