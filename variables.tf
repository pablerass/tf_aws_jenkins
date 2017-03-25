variable "module" {
  type    = "string"
  default = "tf_aws_jenkins"
}

variable "templates" {
  type    = "boolean"
  default = false
}

variable "linux_slave_count" {
  type    = "string"
  default = 0
}

variable "windows_slave_count" {
  type    = "string"
  default = 0
}

variable "iam_user" {
  type    = "string"_
  default = "jenkins"
}

variable "name" {
  description = "Name"
  default     = "jenkis"
}

variable "tags" {
  description = "Resources tags"
  default     = {}
}

variable "admin_cidrs" {
  description = "Adminitration CIDRs for remote access"
  default     = []
}

variable "admin_sg_ids" {
  description = "Adminitration Security Group ids for remote access"
  default     = []
}
