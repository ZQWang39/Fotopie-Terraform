module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.3"

  cluster_name = "FotoPie-with-Fargate"

  tags = {
    Environment = "Development"
    Project     = "FotoPie"
  }
}

resource "aws_ecs_task_definition" "fotopie_task" {
  family = "fotopie_task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1
  memory                   = 2048
  container_definitions = jsonencode([
    {
      name      = "nginxs"
      image     = "public.ecr.aws/nginx/nginx:perl"
      cpu       = 1
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "Linux"
    cpu_architecture        = "X86_64"
  }
  # volume {
  #   name      = "service-storage"
  #   host_path = "/ecs/service-storage"
  # }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}


data "aws_subnets" "default" {
   filter {
    name = "vpc-id"
    values = [var.default_vpc_id]
  }
}



output "subnet_ids" {
  value = data.aws_subnets.default.ids
}

resource "aws_ecs_service" "fotopie_service" {
  name            = "fotopie_service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.fotopie_task.arn
  desired_count   = 2

  network_configuration {
    security_groups  = [application_security_group.alb-sg.id]
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
