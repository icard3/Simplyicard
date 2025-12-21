variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "container_environment" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "simplyicard-cluster"
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "nginx:latest" # Placeholder default
}

variable "desired_capacity" {
  description = "Desired EC2 capacity for ECS cluster"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum EC2 instances for ECS cluster"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum EC2 instances for ECS cluster"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 instance type for ECS Cluster"
  type        = string
  default     = "t3.small"
}

variable "target_group_arn" {
  description = "The ARN of the ALB target group"
  type        = string
}

variable "alb_security_group_id" {
  description = "The ID of the ALB security group"
  type        = string
}
