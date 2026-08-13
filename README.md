# AWS Deployment Automation Pipeline

This project is a portfoilo showcase to show an end-to-end application deployment pipeline using industry standard tools and platforms. The following technologies are being leveraged for this project:

- AWS (cloud infrastructure)
- Terraform (infrastructure as code)
- Docker (image configuration)
- React/Javascript (application/server code)

## Architectural Overview

### Prerequisites

_I should probably set up a separate repo with Terraform to take care of all this later, but for now it's all done manually..._

- Setup Identity Provider in AWS Console
- Create new OIDC role in AWS Console
- Create new ECR repository for custom images
- set ECR Lifecylce Policy to remove unused images
- create S3 bucket for Terraforms state
- create basic VPC for networking
- create ECS cluster

## Resources

- probably the custom image in ECR
- probably ALB
- probably ECS

