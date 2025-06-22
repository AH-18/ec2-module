variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro, m5.large)."
  type        = string
}

variable "keypair_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instance."
  type        = string
}

variable "instance_name" {
  description = "The name to assign to the EC2 instance for identification purposes."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance will be launched."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which the EC2 instance will be placed."
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to be applied to the security group associated with the EC2 instance."
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

variable "egress_rules" {
  description = "List of egress rules to be applied to the security group associated with the EC2 instance."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
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

variable "tags" {
  description = "Tags to be added to the provisioned infrastructure."
  type        = map(string)
  default     = {}
}
