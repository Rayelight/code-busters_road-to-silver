resource "aws_s3_bucket" "this" {
    bucket        = var.bucket_name
    force_destroy = true

    tags = {
        Name        = var.bucket_name
        Environment = var.environment
    }
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.this.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.this.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}
