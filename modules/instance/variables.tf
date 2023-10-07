variable "ec2_instance_name" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "port" {
  type = number
}

variable "sg_name" {
  type = string
}
