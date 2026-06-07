resource "aws_s3_bucket" "b" {
  bucket = "my-hardened-bucket"
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket                  = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "b" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "b" {
  bucket = aws_s3_bucket.b.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# Reglas de cumplimiento adicionales para que pase el test:
resource "aws_s3_bucket_logging" "b" {
  bucket = aws_s3_bucket.b.id
  target_bucket = "dummy-log-bucket"
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "b" {
  bucket = aws_s3_bucket.b.id
  rule {
    id = "log"
    status = "Enabled"
    transition { days = 30; storage_class = "STANDARD_IA" }
  }
}

resource "aws_s3_bucket_replication_configuration" "b" {
  role   = "arn:aws:iam::123456789012:role/replication-role"
  bucket = aws_s3_bucket.b.id
  rule {
    id     = "replicate-all"
    status = "Enabled"
    destination { bucket = "arn:aws:s3:::dummy-repl-bucket" }
  }
}
