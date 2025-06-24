output "bucket_name" {
  description = "Nom du bucket S3"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  description = "ARN complet du bucket"
  value       = aws_s3_bucket.this.arn
}
