# These are my variables for ALB module
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "sg_alb_id" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
