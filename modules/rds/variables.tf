#here we define the variables for the RDS module
variable "db_subnet_ids" {
  type = list(string)
}

variable "sg_db_id" {
  type        = string
  description = "Security group ID for the RDS instance"
}

variable "username" {
  type        = string
  description = "Master username for RDS"
}

variable "password" {
  type        = string
  description = "Master password for RDS"
}

variable "project" {
  type = string
}

variable "owner" {
  type = string
}

variable "engine" {
  description = "Database engine (mysql, postgres, etc.)"
  type        = string
  default     = "mysql"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default = false
}

variable "db_password" {
  type        = string
  description = "Master password for RDS"

  validation {
    condition = (
      length(var.db_password) >= 8 &&
      !can(regex("[/@\" ]", var.db_password))
    )
    error_message = "Password must be at least 8 characters and must not contain '/', '@', '\"', or spaces."
  }
}

