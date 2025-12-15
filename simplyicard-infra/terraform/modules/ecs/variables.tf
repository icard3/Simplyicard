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
