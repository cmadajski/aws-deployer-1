variable "image_tag" {
  description = "The Docker image tag to deploy (passed from GitHub Actions)"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the application (e.g., app.example.com)"
  type        = string
  # default = "app.example.com" # TODO: Provide your domain
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the existing ECS cluster"
  type        = string
}
