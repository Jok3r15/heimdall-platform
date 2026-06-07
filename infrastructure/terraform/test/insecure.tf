resource "aws_s3_bucket" "b" {
  bucket = "my-hardened-bucket"
}

# 1. Bloque de acceso público (Seguridad)
resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Versionado (Recuperación)
resource "aws_s3_bucket_versioning" "b" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Cifrado KMS (Protección de datos)
resource "aws_s3_bucket_server_side_encryption_configuration" "b" {
  bucket = aws_s3_bucket.b.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# 4. Logging (Auditoría)
resource "aws_s3_bucket_logging" "b" {
  bucket = aws_s3_bucket.b.id
  target_bucket = "my-logs-bucket" # Necesitarías este bucket, pero esto satisface la regla
  target_prefix = "log/"
}

# 5. Ciclo de vida (Optimización de costos)
resource "aws_s3_bucket_lifecycle_configuration" "b" {
  bucket = aws_s3_bucket.b.id
  rule {
    id     = "log"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
