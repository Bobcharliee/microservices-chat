variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the RDS instance"
}

variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}