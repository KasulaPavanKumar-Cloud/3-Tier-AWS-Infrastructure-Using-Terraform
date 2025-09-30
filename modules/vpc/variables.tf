# Variables for VPC module
variable "name" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_app_subnets" { type = list(string) }
variable "private_db_subnets" { type = list(string) }
variable "project" { type = string }
variable "owner" { type = string }
variable "availability_zones" {
  description = "List of AZs to distribute subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"] # Skip us-east-1e
}

