provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "random_uuid" "gen" {

}

locals {
  bucket-prefix = "simple-bucket"
  env           = "demo"
  bucket-name   = "${local.bucket-prefix}-${random_uuid.gen.result}-${local.env}"
}

resource "aws_s3_bucket" "private-bucket" {
  bucket = local.bucket-name
  acl    = "private"

  tags = {
    Name = local.bucket-name
    Env  = local.env
  }
}

resource "aws_s3_bucket_public_access_block" "private-bucket-public-access-block" {
  bucket = aws_s3_bucket.private-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

output "bucket" {
  value = local.bucket-name
}
