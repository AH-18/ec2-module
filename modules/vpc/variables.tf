variable "vpc_cidr" {
  description = "The CIDR block to assign to the VPC."
  type        = string
}

variable "vpc_name" {
  description = "The name to assign to the VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "Indicates whether DNS support is enabled for the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Indicates whether DNS hostnames are enabled for the VPC."
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = "A list of public subnets with CIDR blocks, availability zones, and mapping options for public IPs."
  type = list(object({
    cidr                    = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
  default = []
}



variable "tags" {
  description = "Tags to assign to the VPC and its associated resources."
  type        = map(string)
  default     = {}
}
