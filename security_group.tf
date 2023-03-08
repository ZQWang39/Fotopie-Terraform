
module "alb-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  
  name        = "application-loadbalancer-security-group"
  description = "Inbound traffic port 80 from anywhere"
  vpc_id      = var.default_vpc_id

  ingress_with_cidr_blocks = [
    {
      description      = "Inbound traffic port 80 from external"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
   }
  ]
}


module "ecs-security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  
  name        = "ecs-tasks-security-group"
  description = "Inbound traffic from ApplicationLoadBalancerSG"
  vpc_id      = var.default_vpc_id
      
  ingress_with_source_security_group_id = [
    {
      description      = "Inbound traffic ApplicationLoadBalancerSG"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      source_security_group_id  = module.alb-security-group.security_group_id
    }
  ]
  
  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
   }
  ]
}
# # ALB Security Group: Edit to restrict access to the application
# resource "aws_security_group" "alb-sg" {
#   name        = "application-loadbalancer-security-group"
#   description = "Inbound traffic to port 80 from anywhere"
#   vpc_id      = var.default_vpc_id

#   ingress {
#     protocol    = "tcp"
#     from_port   = 80
#     to_port     = 80
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # this security group for ecs - Traffic to the ECS cluster should only come from the ALB
# resource "aws_security_group" "ecs_sg" {
#   name        = "ecs-tasks-security-group"
#   description = "allow inbound traffic from the ALB only"
#   vpc_id      = var.default_vpc_id

#   ingress {
#     protocol        = "tcp"
#     from_port       = 0
#     to_port         = 65535
#     security_groups = [aws_security_group.alb-sg.id]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
