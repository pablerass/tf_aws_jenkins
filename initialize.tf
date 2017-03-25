variable "key_pair" {
  type = "string"
}

variable "ami_linux" {
  type = "string"
}

variable "ami_windows" {
  type = "string"
}

variable "master_instance_type" {
  type = "string"
}

variable "linux_slave_instance_type" {
  type = "string"
}

variable "windows_slave_instance_type" {
  type = "string"
}

variable "slaves_key" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "pgp_key" {
  type = "string"
}
