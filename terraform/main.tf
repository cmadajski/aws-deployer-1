terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # backend "s3" {} # TODO: Configure a remote state bucket here!
}

provider "aws" {
  region = "us-east-1"
}

# Fetch the existing VPC
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Fetch the public Subnets in the VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Fetch the Route53 Zone based on the domain name
# (assumes the domain_name is a subdomain like app.example.com and the zone is example.com)
data "aws_route53_zone" "main" {
  name         = join(".", slice(split(".", var.domain_name), 1, length(split(".", var.domain_name))))
  private_zone = false
}

# Fetch the existing ECS Cluster
data "aws_ecs_cluster" "main" {
  cluster_name = var.ecs_cluster_name
}
