resource "aws_s3_bucket" "b" {
  bucket = "my-hardened-bucket"
}

resource "aws_s3_bucket_versioning" "b_versioning" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "b_public_access" {
  bucket = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "b_lifecycle" {
  bucket = aws_s3_bucket.b.id
  rule {
    id     = "log-expiry"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket_logging" "b_logging" {
  bucket        = aws_s3_bucket.b.id
  target_bucket = "my-logging-bucket"
  target_prefix = "log/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "b_encryption" {
  bucket = aws_s3_bucket.b.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "b_replication" {
  depends_on = [aws_s3_bucket_versioning.b_versioning]
  role   = "arn:aws:iam::123456789012:role/replication-role"
  bucket = aws_s3_bucket.b.id
  rule {
    id     = "replicate-all"
    status = "Enabled"
    destination {
      bucket        = "arn:aws:s3:::my-destination-bucket"
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_notification" "b_notification" {
  bucket = aws_s3_bucket.b.id
  lambda_function {
    lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    events              = ["s3:ObjectCreated:*"]
  }
}
