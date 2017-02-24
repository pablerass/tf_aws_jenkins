resource "aws_iam_user" "jenkins" {
  name = "jenkins"
}

resource "aws_iam_access_key" "jenkins" {
  user    = "${aws_iam_user.jenkins.name}"
  pgp_key = "${var.encrypt_pgp_key}"
}

resource "aws_iam_user_policy" "jenkins_manage_ec2_slaves" {
  name = "jenkins-manage-ec2-slaves"
  user = "${aws_iam_user.jenkins.name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1312295543082",
            "Action": [
                "ec2:DescribeSpotInstanceRequests",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetConsoleOutput",
                "ec2:RequestSpotInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}