# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "aws-deployer-1-ecs-tasks-sg"
  vpc_id      = data.aws_vpc.main.id

  # Only allow ingress traffic from the Application Load Balancer
  ingress {
    protocol        = "tcp"
    from_port       = 8080 # TODO: Update to match your app's exposed port
    to_port         = 8080
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "aws-deployer-1-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  # Explicitly target ARM64 to run on AWS Graviton!
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([{
    name      = "aws-deployer-1-app"
    image     = "753520288508.dkr.ecr.us-east-1.amazonaws.com/aws-deployer-1:${var.image_tag}"
    essential = true
    
    portMappings = [{
      protocol      = "tcp"
      containerPort = 8080 # TODO: Update to match your app's exposed port
      hostPort      = 8080
    }]
  }])
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "aws-deployer-1-service"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnets.public.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "aws-deployer-1-app"
    container_port   = 8080
  }

  depends_on = [aws_alb_listener.https]
}
