# Bucket principal
resource "aws_s3_bucket" "b" {
  bucket = "my-hardened-bucket"
}

# 1. Habilitar Logging (CKV_AWS_18)
resource "aws_s3_bucket_logging" "b_logging" {
  bucket = aws_s3_bucket.b.id
  target_bucket = "my-logging-bucket" # Nota: En un caso real, esto debe existir
  target_prefix = "log/"
}

# 2. Habilitar Cifrado KMS (CKV_AWS_145)
resource "aws_s3_bucket_server_side_encryption_configuration" "b_encryption" {
  bucket = aws_s3_bucket.b.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# 3. Habilitar Lifecycle (CKV2_AWS_61)
resource "aws_s3_bucket_lifecycle_configuration" "b_lifecycle" {
  bucket = aws_s3_bucket.b.id
  rule {
    id     = "log-expiry"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

# 4. Habilitar Replicación (CKV_AWS_144)
# (Nota: Requiere IAM Role, esto es la definición del recurso)
resource "aws_s3_bucket_replication_configuration" "b_replication" {
  depends_on = [aws_s3_bucket_versioning.b]
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

# 5. Event Notifications (CKV2_AWS_62)
resource "aws_s3_bucket_notification" "b_notification" {
  bucket = aws_s3_bucket.b.id
  lambda_function {
    lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    events              = ["s3:ObjectCreated:*"]
  }
}
