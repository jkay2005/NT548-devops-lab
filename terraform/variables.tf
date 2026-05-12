variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" {
  description = "Project name used in tags and resource names"
  type        = string
  default     = "nt548-devops-lab"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR is required."
  }
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

variable "availability_zones" {
  description = "Optional AZ list. Leave empty to auto-pick available AZs"
  type        = list(string)
  default     = []

  validation {
    condition = (
      length(var.availability_zones) == 0 ||
      length(var.availability_zones) >= max(length(var.public_subnet_cidrs), length(var.private_subnet_cidrs))
    )
    error_message = "availability_zones must be empty or include enough AZs for all public/private subnets."
  }
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR format for SSH to bastion, e.g. 1.2.3.4/32"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip_cidr, 0))
    error_message = "my_ip_cidr must be a valid CIDR block like 1.2.3.4/32."
  }
}

variable "key_name" {
  description = "Optional EC2 key pair name"
  type        = string
  default     = null
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t2.micro"
}

variable "private_instance_type" {
  description = "Instance type for private node (K3s/Minikube host)"
  type        = string
  default     = "t2.medium"
}
