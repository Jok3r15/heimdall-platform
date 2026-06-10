# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# S3 Bucket to store the Terraform state file
# Versioning is enabled to track history and recover from accidental state deletion
resource "aws_s3_bucket" "terraform_state" {
  bucket = "heimdall-terraform-state-2026"

  # Prevents accidental deletion of the state bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning for the S3 bucket to provide a safety net
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table to handle state locking
# This prevents race conditions when multiple users or CI/CD pipelines run terraform apply
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "heimdall-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
