variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr1" {
  description = "Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "subnet_cidr2" {
  description = "Subnet CIDR"
  default     = "192.168.2.0/24"
}
variable "subnet_cidr3" {
  description = "Subnet CIDR"
  default     = "192.168.3.0/24"
}
variable "subnet_cidr4" {
  description = "Subnet CIDR"
  default     = "192.168.4.0/24"
}

variable "default_route"{
  description = "Default route"
  default     = "0.0.0.0/0"
}

variable "home_net" {
  description = "Home network"
  default     = "192.168.1.0/24"
}

variable "bcit_net" {
  description = "BCIT network"
  default     = "142.232.0.0/16"
  
}
