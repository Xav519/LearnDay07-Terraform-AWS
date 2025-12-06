variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"

# Enforces the region variable is one of the unique values defined in the allowed_region set
  validation {
    condition     = contains(var.allowed_regions, var.region)
    error_message = "Region must be one of the allowed regions."
  }
}

variable "environment" {
  description = "The environment for tagging resources"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "my-unique-bucket-12345-519"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}

variable "monitoring_enabled" {
  description = "Enable monitoring for EC2 instances"
  type        = bool
  default     = true
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instances"
  type        = bool
  default     = true
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = list(string)
  default     = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

variable allowed_vm_types {
  description = "List of allowed VM types"
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable allowed_regions {
  description = "List of allowed AWS regions"
  type        = set(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable tags {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {
    Environment = "dev", 
    Name = "dev-Instance", 
    created_by = "terraform"
    }
}

variable ingress_values {
  description = "List of ingress rules for security group"
  type = tuple([ number, string, number ])
  default = [ 443, "tcp", 443 ]
}
