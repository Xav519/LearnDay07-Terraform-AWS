resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = local.fullBucketName
  }
}

resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[0]
  count         = var.config.instance_count
  monitoring = var.config.monitoring
  associate_public_ip_address = var.associate_public_ip

  lifecycle {
    precondition {
      error_message = "Instance type must be in the allowed list"
      #check that the instance_type is part of the allowed list
      #checks if vm.allowed_vm_types[0] is in the var.allowed_vm_types list
      condition     = contains(var.allowed_vm_types, var.allowed_vm_types[0])
    }
  }

  tags = {
    Name        = "ExampleInstance"
    Environment = var.environment
  }
}

resource "aws_vpc" "example" {
  cidr_block = var.cidr_block[0]

  # Added variable tags to the VPC resource
  tags = var.tags 
  
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.cidr_block[1]
  availability_zone = "us-east-1a"

  tags = {
    Name        = "ExampleSubnet"
    Environment = var.environment
  }
}

resource "aws_subnet" "example2" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.cidr_block[2]
  availability_zone = "us-east-1b"

  tags = {
    Name        = "ExampleSubnet2"
    Environment = var.environment
  }
}