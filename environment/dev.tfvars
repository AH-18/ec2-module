# General
aws_region       = "us-east-1"
secondary_region = ""
environment      = "dev"
project          = "sonerqube-server"


# vpc & network variables 

vpc_cidr = "10.0.0.0/16"
# Public Subnets (2 subnets in different AZs)
public_subnets = [
  { cidr = "10.0.0.0/20", availability_zone = "us-east-1a", map_public_ip_on_launch = true }
]



enable_s3_endpoint = false


# # Load Balancer Configuration
# lb_name              = "scoold-alb-dev"
# lb_internal          = false
# lb_listener_port     = 80
# lb_listener_protocol = "HTTP"

# lb_target_groups = {
#   scoold = {
#     name        = "scoold-tg"
#     port        = 8000
#     protocol    = "HTTP"
#     target_type = "ip"
#     health_check = {
#       enabled             = true
#       healthy_threshold   = 3
#       interval            = 30
#       matcher             = "200"
#       path                = "/health"
#       port                = "traffic-port"
#       protocol            = "HTTP"
#       timeout             = 5
#       unhealthy_threshold = 3
#     }
#   }
# }



# EC2 Configuration
ami_id        = "ami-020cba7c55df1f615"
instance_type = "t3.large"
keypair_name  = "soner_key"

# Example security group rules
ingress_rules = [
  {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "Allow sonerqube access"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

]
