output "bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "vpc_name" {
  description = "The ID of the created VPC"
  value       = aws_vpc.example.tags["Name"]
}

output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    environment    = var.environment
    instance_count = var.config.instance_count
    name_tag = aws_instance.example[0].tags["Name"]
  }
}