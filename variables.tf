variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1" # Change this to your preferred region
}

# variable "secondary_region" {
#   type        = string
#   description = "The AWS region"
#   default     = "us-east-2"
# }

variable "environment" {
  type        = string
  description = "The deployment environment (dev, staging, or prod)"
}

variable "project" {
  type        = string
  description = "The name of the project (also used as prefix for the resources)."
}

variable "access_key" {
  type        = string
  description = "The IAM access key"
}

variable "secret_key" {
  type        = string
  description = "The IAM secret key"
}

###########################################
##             Tags Variables            ##
###########################################
variable "tags" {
  type        = map(string)
  description = "Tags to be added to the provisioned infrastructure."
  default     = {}
}



###########################################
##            VPC Variables              ##
###########################################
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets, each defined by its CIDR block, availability zone, and public IP mapping configuration."
  type = list(object({
    cidr                    = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = []
}


# variable "enable_s3_endpoint" {
#   description = "Enable the creation of an S3 Gateway Endpoint"
#   type        = bool
# }


###########################################
##            EC2 Variables              ##
###########################################

variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro, m5.large)."
  type        = string
  default     = "t2.micro"
}

variable "keypair_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instance."
  type        = string
}

# variable "instance_name" {
#   description = "The name to assign to the EC2 instance for identification purposes."
#   type        = string
# }

variable "ingress_rules" {
  description = "List of ingress rules for EC2 security group."
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string), [])
    security_groups = optional(list(string), [])
  }))
  default = []
}

variable "iam_permissions" {
  description = "List of IAM permissions or policies to attach to the EC2 instance role."
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the EC2 instance."
  type        = bool
  default     = true
}

variable "root_block_device" {
  description = "Configuration of the root block device for the EC2 instance."
  type = object({
    size                  = number
    type                  = string
    encrypted             = bool
    delete_on_termination = bool
  })
  default = {
    size                  = 100
    type                  = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
}