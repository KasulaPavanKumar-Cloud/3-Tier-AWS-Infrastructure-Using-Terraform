#Here we declare All variables for the dev environment are defined here
variable "region" { type = string }
variable "owner" {
  type    = string
  default = "pavan"
}
variable "project" {
  type    = string
  default = "3Tier"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_app_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "private_db_subnets" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "web_ami" { type = string }
variable "app_ami" { type = string }
variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_username" {
  type        = string
  description = "Master username for RDS"
}


variable "db_password" {
  type        = string
  description = "Master password for RDS"
}

# variables.tf

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_app_subnet_ids" {
  type        = list(string)
  description = "List of private application subnet CIDRs"
}

variable "private_db_subnet_ids" {
  type        = list(string)
  description = "List of private database subnet CIDRs"
}


variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg_db_id" {
  type        = string
  description = "Security group ID for the RDS instance"
}

variable "db_multi_az" {
  type        = bool
  description = "Whether to enable Multi-AZ deployment for RDS"
  default     = false  # You can override this in terraform.tfvars
}

variable "db_allocated_storage" {
  type        = number
  description = "The amount of allocated storage for the RDS instance in GB"
}

variable "db_instance_class" {
  type        = string
  description = "The instance class for the RDS database (e.g., db.t3.micro)"
}

variable "db_engine" {
  type        = string
  description = "The database engine to use for RDS (e.g., mysql, postgres)"
}

