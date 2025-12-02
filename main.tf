resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = local.fullBucketName
  }
}

resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t2.micro"
  count         = var.instance_count
  monitoring = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name        = "ExampleInstance"
    Environment = var.environment
  }
}

resource "aws_vpc" "example" {
  cidr_block = var.cidr_block[0]

  tags = {
    Name        = "ExampleVPC"
    Environment = var.environment
  }
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