module "ec2_instance" {
  source = "./modules/ec2"
  # Required parameters
  ami_id        = var.ami_id
  instance_type = var.instance_type
  keypair_name  = var.keypair_name
  instance_name = "${var.project}-sonerqube-server-${var.environment}"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]

  # Optional parameters with defaults
  ingress_rules               = var.ingress_rules
  iam_permissions             = var.iam_permissions
  associate_public_ip_address = var.associate_public_ip_address
  root_block_device           = var.root_block_device
  
  # SonarQube automated setup script
  user_data = file("${path.root}/sonarqube_setup.sh")
  # Tags
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project
    Purpose     = "sonerqube server"
    Application = "SonarQube"
    Role        = "Code Quality Analysis Server"
  })
}
