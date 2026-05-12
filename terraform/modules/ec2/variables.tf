variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "private_node_sg_id" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "private_instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
