terraform {
  backend "s3" {
    bucket         = "heimdall-terraform-state-2026" # Cámbialo si ya existe
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "heimdall-terraform-lock"
    encrypt        = true
  }
}
