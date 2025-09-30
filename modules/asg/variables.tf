variable "name" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "iam_instance_profile" { type = string }
variable "desired_capacity" {
  type    = number
  default = 1
}
variable "min_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 2
}
variable "target_group_arns" {
  type    = list(string)
  default = []
}
variable "project" { type = string }
variable "owner" { type = string }
