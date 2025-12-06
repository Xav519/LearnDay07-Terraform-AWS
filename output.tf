output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "vpc_name" {
  description = "The ID of the created VPC"
  value       = aws_vpc.example.tags["Name"]
}