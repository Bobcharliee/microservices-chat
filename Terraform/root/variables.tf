variable project_name {
  description = "The name of the project"
  type        = string
}

variable vpc_cidr_block {
  description = "The CIDR block for the VPC"
  type        = string
}

variable pub_subnet_1a_cidr_block {
  description = "The CIDR block for the public subnet in availability zone 1a"
  type        = string
}

variable pub_subnet_2a_cidr_block {
  description = "The CIDR block for the public subnet in availability zone 2a"
  type        = string
}

variable priv_subnet_1a_cidr_block {
  description = "The CIDR block for the private subnet in availability zone 1a"
  type        = string
}

variable priv_subnet_1b_cidr_block {
  description = "The CIDR block for the private subnet in availability zone 1b"
  type        = string
}

variable priv_subnet_2a_cidr_block {
  description = "The CIDR block for the private subnet in availability zone 1a"
  type        = string
}

variable priv_subnet_2b_cidr_block {
  description = "The CIDR block for the private subnet in availability zone 1b"
  type        = string
}

variable aws_region {
  description = "The AWS region to deploy resources"
  type        = string
}

variable instance_type {
  description = "The EC2 instance type for the ASG"
  type        = string
}

variable root_volume_size {
  description = "The size of the root volume for the EC2 instances"
  type        = number
}

variable root_volume_type {
  description = "The type of the root volume for the EC2 instances"
  type        = string
}

variable max_size {
  description = "The maximum size of the ASG"
  type        = number
}

variable min_size {
  description = "The minimum size of the ASG"
  type        = number
}

variable desired_capacity {
  description = "The desired capacity of the ASG"
  type        = number
}

variable key_name {
  description = "The name of the SSH key pair to use for the EC2 instances"
  type        = string
}

variable http_port {
  description = "The HTTP port for the security group"
  type        = number
}

variable http_port_2 {
  description = "The second HTTP port for the security group"
  type        = number
}

variable https_port {
  description = "The HTTPS port for the security group"
  type        = number
}

variable ssh_port {
  description = "The SSH port for the security group"
  type        = number
}

variable tcp_protocol {
  description = "The TCP protocol for the security group"
  type        = string
}

variable ssh_protocol {
  description = "The SSH protocol for the security group"
  type        = string
}

variable mysql_port {
  description = "The MySQL port for the security group"
  type        = number
}

variable db_username {
  description = "The username for the RDS database"
  type        = string
}

